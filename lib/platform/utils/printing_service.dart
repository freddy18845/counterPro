import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ux/models/shared/sale_order.dart';
import '../../ux/models/shared/pos_transaction.dart';
import '../../ux/utils/sessionManager.dart';
import 'dart:io';

import 'constant.dart';

class PrinterManager {
  // ── Singleton ─────────────────────────────────────────────
  static final PrinterManager _instance = PrinterManager._internal();
  factory PrinterManager() => _instance;
  PrinterManager._internal();

  // Platform channel for Windows USB printing
  static const MethodChannel _windowsUsbChannel = MethodChannel('usb_printer_windows');

  UsbPort? _usbPort;
  final BluetoothPrint _bluetooth = BluetoothPrint.instance;
  bool _bluetoothConnected = false;
  String _connectionType = ''; // 'usb' or 'bluetooth'
  String? _windowsPrinterName;

  // saved printer address for auto-reconnect
  static const _prefKey = 'saved_printer_address';

  // ── Connection state ──────────────────────────────────────
  bool get isConnected =>
      _connectionType == 'usb' ||
          (_connectionType == 'bluetooth' && _bluetoothConnected);

  String get connectionType => _connectionType;

  // ─────────────────────────────────────────────────────────
  // ── USB CONNECTION ────────────────────────────────────────
  // ─────────────────────────────────────────────────────────
  Future<bool> connectUSB() async {
    try {
      // 🪟 WINDOWS
      if (Platform.isWindows) {
        final printers = await _getUSBPrinters();

        if (printers.isEmpty) {
          debugPrint('❌ No USB printers found (Windows)');
          return false;
        }

        // pick first printer (you can improve UI later)
        _windowsPrinterName = printers.first;

        _connectionType = 'usb';
        debugPrint('✅ Windows USB connected: $_windowsPrinterName');
        return true;
      }

      // 📱 ANDROID
      final devices = await UsbSerial.listDevices();

      if (devices.isEmpty) {
        debugPrint('❌ No USB devices found');
        return false;
      }

      _usbPort = await devices.first.create();

      if (!await _usbPort!.open()) {
        debugPrint('❌ Failed to open USB port');
        return false;
      }

      await _usbPort!.setDTR(true);
      await _usbPort!.setRTS(true);
      await _usbPort!.setPortParameters(
        9600,
        UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE,
      );

      _connectionType = 'usb';
      debugPrint('✅ Android USB connected');
      return true;

    } catch (e) {
      debugPrint('❌ USB connect error: $e');
      return false;
    }
  }

  // Get list of USB printers on Windows
  Future<List<String>> _getUSBPrinters() async {
    try {
      final List<dynamic> result = await _windowsUsbChannel.invokeMethod('getPrinters');
      return result.cast<String>();
    } catch (e) {
      debugPrint('Failed to get printers: $e');
      return [];
    }
  }

  // Print raw bytes on Windows
  Future<bool> _printWindowsRawData(String printerName, List<int> data) async {
    try {
      final bool result = await _windowsUsbChannel.invokeMethod('printBytes', {
        'printerName': printerName,
        'bytes': data,
      });
      return result;
    } catch (e) {
      debugPrint('Windows print error: $e');
      return false;
    }
  }

  Future<void> disconnectUSB() async {
    await _usbPort?.close();
    _usbPort = null;
    _connectionType = '';
  }

  // ─────────────────────────────────────────────────────────
  // ── BLUETOOTH CONNECTION ──────────────────────────────────
  // ─────────────────────────────────────────────────────────
  Future<List<BluetoothDevice>> scanBluetooth() async {
    final devices = <BluetoothDevice>[];
    _bluetooth.scanResults.listen((results) {
      devices.clear();
      devices.addAll(results);
    });
    await _bluetooth.startScan(
        timeout: const Duration(seconds: 4));
    return devices;
  }

  Future<bool> connectBluetooth(BluetoothDevice device) async {
    try {
      final result = await _bluetooth.connect(device);
      _bluetoothConnected = result;

      if (result) {
        _connectionType = 'bluetooth';
        // save for auto-reconnect
        await _savePrinterAddress(device.address ?? '');
        debugPrint('✅ Bluetooth connected: ${device.name}');
      } else {
        debugPrint('❌ Bluetooth connection failed');
      }
      return result;
    } catch (e) {
      debugPrint('❌ Bluetooth connect error: $e');
      return false;
    }
  }

  Future<void> disconnectBluetooth() async {
    await _bluetooth.disconnect();
    _bluetoothConnected = false;
    _connectionType = '';
  }

  // ── Auto-reconnect saved printer ─────────────────────────
  Future<void> autoReconnect() async {
    final address = await _getSavedPrinterAddress();
    if (address == null || address.isEmpty) return;

    _bluetooth.scanResults.listen((devices) async {
      for (final d in devices) {
        if (d.address == address) {
          await connectBluetooth(d);
          debugPrint('✅ Auto-reconnected to ${d.name}');
          return;
        }
      }
    });

    await _bluetooth.startScan(
        timeout: const Duration(seconds: 3));
  }

  Future<void> _savePrinterAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, address);
  }

  Future<String?> _getSavedPrinterAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefKey);
  }

  Future<void> clearSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }

  // ─────────────────────────────────────────────────────────
  // ── BUILD USB RECEIPT (ESC/POS) ───────────────────────────
  // ─────────────────────────────────────────────────────────
  Future<List<int>> _buildUsbReceipt({
    required SaleOrder order,
    required PosTransaction transaction,
    bool isDuplicate = false,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final session = SessionManager();
    List<int> bytes = [];

    // ── Logo ───────────────────────────────────────────────
    try {
      if (session.companyLogoPath != null) {
        final data =
        await rootBundle.load(session.companyLogoPath!);
        final image =
        img.decodeImage(data.buffer.asUint8List());
        if (image != null) {
          bytes += generator.image(image,
              align: PosAlign.center);
          bytes += generator.feed(1);
        }
      }
    } catch (e) {
      print(e);
      // logo not available — skip
    }

    // ── Company header ─────────────────────────────────────
    bytes += generator.text(
      session.companyName ?? 'CounterPro',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    if (session.companyAddress != null) {
      bytes += generator.text(
        session.companyAddress!,
        styles: const PosStyles(align: PosAlign.center),
      );
    }

    if (session.companyContactOne != null) {
      bytes += generator.text(
        session.companyContactOne!,
        styles: const PosStyles(align: PosAlign.center),
      );
    }

    if (session.companyEmail != null) {
      bytes += generator.text(
        session.companyEmail!,
        styles: const PosStyles(align: PosAlign.center),
      );
    }

    bytes += generator.hr();

    // ── Receipt type ───────────────────────────────────────
    bytes += generator.text(
      isDuplicate ? 'DUPLICATE RECEIPT' : 'RECEIPT',
      styles: const PosStyles(
          align: PosAlign.center, bold: true),
    );

    bytes += generator.hr();

    // ── Meta ───────────────────────────────────────────────
    bytes += generator.row([
      PosColumn(
          text: 'Order:',
          width: 4,
          styles: const PosStyles(bold: true)),
      PosColumn(text: order.orderNumber, width: 8),
    ]);

    bytes += generator.row([
      PosColumn(
          text: 'Date:',
          width: 4,
          styles: const PosStyles(bold: true)),
      PosColumn(
          text: DateFormat('dd/MM/yy HH:mm')
              .format(transaction.timestamp),
          width: 8),
    ]);

    bytes += generator.row([
      PosColumn(
          text: 'Teller:',
          width: 4,
          styles: const PosStyles(bold: true)),
      PosColumn(
          text: session.userName ?? '-', width: 8),
    ]);

    bytes += generator.row([
      PosColumn(
          text: 'Method:',
          width: 4,
          styles: const PosStyles(bold: true)),
      PosColumn(
          text: _paymentLabel(transaction.paymentMethod),
          width: 8),
    ]);

    bytes += generator.hr();

    // ── Items header ───────────────────────────────────────
    bytes += generator.row([
      PosColumn(
          text: 'Item',
          width: 6,
          styles: const PosStyles(
              bold: true, underline: true)),
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: const PosStyles(
              bold: true, underline: true)),
      PosColumn(
          text: 'Total',
          width: 4,
          styles: const PosStyles(
              bold: true,
              underline: true,
              align: PosAlign.right)),
    ]);

    // ── Items ──────────────────────────────────────────────
    for (final item in order.items) {
      final name = item.productName.length > 14
          ? '${item.productName.substring(0, 14)}..'
          : item.productName;

      bytes += generator.row([
        PosColumn(text: name, width: 6),
        PosColumn(text: 'x${item.quantity}', width: 2),
        PosColumn(
            text:
            '${ConstantUtil.currencySymbol} ${item.totalPrice.toStringAsFixed(2)}',
            width: 4,
            styles: const PosStyles(
                align: PosAlign.right)),
      ]);

      // unit price hint
      bytes += generator.text(
        '  @ ${ConstantUtil.currencySymbol} ${item.unitPrice.toStringAsFixed(2)} each',
        styles: const PosStyles(
            fontType: PosFontType.fontB,
            align: PosAlign.left),
      );
    }

    bytes += generator.hr();

    // ── Totals ─────────────────────────────────────────────
    bytes += generator.row([
      PosColumn(text: 'Subtotal:', width: 7),
      PosColumn(
          text:
          '${ConstantUtil.currencySymbol}${order.subtotal.toStringAsFixed(2)}',
          width: 5,
          styles: const PosStyles(
              align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: 'Tax:', width: 7),
      PosColumn(
          text:
          '${ConstantUtil.currencySymbol} ${order.taxAmount.toStringAsFixed(2)}',
          width: 5,
          styles: const PosStyles(
              align: PosAlign.right)),
    ]);

    if (order.discountAmount > 0) {
      bytes += generator.row([
        PosColumn(text: 'Discount:', width: 7),
        PosColumn(
            text:
            '-${ConstantUtil.currencySymbol} ${order.discountAmount.toStringAsFixed(2)}',
            width: 5,
            styles: const PosStyles(
                align: PosAlign.right)),
      ]);
    }

    bytes += generator.hr(linesAfter: 1);

    bytes += generator.row([
      PosColumn(
          text: 'TOTAL:',
          width: 6,
          styles: const PosStyles(
              bold: true, height: PosTextSize.size2)),
      PosColumn(
          text:
          '${ConstantUtil.currencySymbol} ${order.totalAmount.toStringAsFixed(2)}',
          width: 6,
          styles: const PosStyles(
              bold: true,
              height: PosTextSize.size2,
              align: PosAlign.right)),
    ]);

    bytes += generator.feed(1);

    bytes += generator.row([
      PosColumn(text: 'Paid:', width: 7),
      PosColumn(
          text:
          '${ConstantUtil.currencySymbol} ${transaction.amountPaid.toStringAsFixed(2)}',
          width: 5,
          styles: const PosStyles(
              align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: 'Change:', width: 7),
      PosColumn(
          text:
          '${ConstantUtil.currencySymbol} ${transaction.changeGiven.toStringAsFixed(2)}',
          width: 5,
          styles: const PosStyles(
              align: PosAlign.right)),
    ]);

    bytes += generator.hr();

    // ── QR code (order number) ─────────────────────────────
    bytes += generator.qrcode(
      order.orderNumber,
      size: QRSize.Size4,
      cor: QRCorrection.M,
    );

    // ── Barcode (transaction number) ───────────────────────
    try {
      bytes += generator.barcode(
        Barcode.code128(
            utf8.encode(transaction.transactionNumber)),
        width: 2,
        height: 60,
        align: PosAlign.center,
      );
    } catch (_) {}

    bytes += generator.hr();

    // ── Footer ─────────────────────────────────────────────
    bytes += generator.text(
      'Thank You For Your Purchase!',
      styles: const PosStyles(align: PosAlign.center),
    );

    if (session.companySlogan != null) {
      bytes += generator.text(
        session.companySlogan!,
        styles: const PosStyles(align: PosAlign.center),
      );
    }

    bytes += generator.feed(3);
    bytes += generator.cut();

    return bytes;
  }

  // ─────────────────────────────────────────────────────────
  // ── BUILD BLUETOOTH RECEIPT ───────────────────────────────
  // ─────────────────────────────────────────────────────────
  List<LineText> _buildBluetoothReceipt({
    required SaleOrder order,
    required PosTransaction transaction,
    bool isDuplicate = false,
  }) {
    final list = <LineText>[];
    final session = SessionManager();

    // ── Header ─────────────────────────────────────────────
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: session.companyName ?? 'CounterPro',
      align: LineText.ALIGN_CENTER,
      weight: 2,
      size: 2,
      linefeed: 1,
    ));

    if (session.companyAddress != null) {
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: session.companyAddress!,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ));
    }

    if (session.companyContactOne != null) {
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: session.companyContactOne!,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ));
    }

    list.add(_btDivider());

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content:
      isDuplicate ? 'DUPLICATE RECEIPT' : 'RECEIPT',
      align: LineText.ALIGN_CENTER,
      weight: 1,
      linefeed: 1,
    ));

    list.add(_btDivider());

    // ── Meta ───────────────────────────────────────────────
    list.add(_btRow('Order:', order.orderNumber));
    list.add(_btRow(
      'Date:',
      DateFormat('dd/MM/yy HH:mm')
          .format(transaction.timestamp),
    ));
    list.add(
        _btRow('Teller:', session.userName ?? '-'));
    list.add(_btRow(
      'Method:',
      _paymentLabel(transaction.paymentMethod),
    ));

    list.add(_btDivider());

    // ── Items header ───────────────────────────────────────
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Item            Qty   Total',
      weight: 1,
      linefeed: 1,
    ));

    list.add(_btDottedLine());

    // ── Items ──────────────────────────────────────────────
    for (final item in order.items) {
      final name = item.productName.length > 14
          ? '${item.productName.substring(0, 14)}..'
          : item.productName.padRight(16);
      final qty = 'x${item.quantity}'.padRight(6);
      final total =
          '${ConstantUtil.currencySymbol} ${item.totalPrice.toStringAsFixed(2)}';

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '$name$qty$total',
        linefeed: 1,
      ));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
        '  @ ${ConstantUtil.currencySymbol} ${item.unitPrice.toStringAsFixed(2)} each',
        linefeed: 1,
      ));
    }

    list.add(_btDivider());

    // ── Totals ─────────────────────────────────────────────
    list.add(_btRow(
      'Subtotal:',
      '${ConstantUtil.currencySymbol} ${order.subtotal.toStringAsFixed(2)}',
    ));
    list.add(_btRow(
      'Tax:',
      '${ConstantUtil.currencySymbol} ${order.taxAmount.toStringAsFixed(2)}',
    ));

    if (order.discountAmount > 0) {
      list.add(_btRow(
        'Discount:',
        '-${ConstantUtil.currencySymbol} ${order.discountAmount.toStringAsFixed(2)}',
      ));
    }

    list.add(_btDivider());

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content:
      'TOTAL:  ${ConstantUtil.currencySymbol} ${order.totalAmount.toStringAsFixed(2)}',
      weight: 2,
      size: 2,
      align: LineText.ALIGN_CENTER,
      linefeed: 1,
    ));

    list.add(_btRow(
      'Paid:',
      '${ConstantUtil.currencySymbol} ${transaction.amountPaid.toStringAsFixed(2)}',
    ));
    list.add(_btRow(
      'Change:',
      '${ConstantUtil.currencySymbol} ${transaction.changeGiven.toStringAsFixed(2)}',
    ));

    list.add(_btDivider());

    // ── QR code ────────────────────────────────────────────
    list.add(LineText(
      type: LineText.TYPE_QRCODE,
      content: order.orderNumber,
      align: LineText.ALIGN_CENTER,
      size: 5,
      linefeed: 1,
    ));

    list.add(_btDivider());

    // ── Footer ─────────────────────────────────────────────
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Thank you for your purchase!',
      align: LineText.ALIGN_CENTER,
      linefeed: 1,
    ));

    if (session.companySlogan != null) {
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: session.companySlogan!,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ));
    }

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '',
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '',
        linefeed: 1));

    return list;
  }

  // ─────────────────────────────────────────────────────────
  // ── REPORT RECEIPT ────────────────────────────────────────
  // ─────────────────────────────────────────────────────────
  Future<List<int>> _buildUsbReport({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required double totalRevenue,
    required double totalCost,
    required double grossProfit,
    required int totalOrders,
    required int totalItems,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final session = SessionManager();
    final fmt = DateFormat('dd/MM/yyyy');
    List<int> bytes = [];

    bytes += generator.text(
      session.companyName ?? 'CounterPro',
      styles: const PosStyles(
          align: PosAlign.center, bold: true),
    );

    bytes += generator.text(
      'SALES REPORT',
      styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2),
    );

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: 'From:', width: 5),
      PosColumn(text: fmt.format(startDate), width: 7),
    ]);
    bytes += generator.row([
      PosColumn(text: 'To:', width: 5),
      PosColumn(text: fmt.format(endDate), width: 7),
    ]);
    bytes += generator.row([
      PosColumn(text: 'By:', width: 5),
      PosColumn(
          text: session.userName ?? '-', width: 7),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Printed:', width: 5),
      PosColumn(
          text: DateFormat('dd/MM/yy HH:mm')
              .format(DateTime.now()),
          width: 7),
    ]);

    bytes += generator.hr();
    bytes += generator.text('SUMMARY',
        styles: const PosStyles(
            align: PosAlign.center, bold: true));
    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(text: 'Orders:', width: 7),
      PosColumn(
          text: totalOrders.toString(),
          width: 5,
          styles:
          const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Items Sold:', width: 7),
      PosColumn(
          text: totalItems.toString(),
          width: 5,
          styles:
          const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Revenue:', width: 7),
      PosColumn(
          text:
          '\$${totalRevenue.toStringAsFixed(2)}',
          width: 5,
          styles:
          const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Cost:', width: 7),
      PosColumn(
          text: '${ConstantUtil.currencySymbol} ${totalCost.toStringAsFixed(2)}',
          width: 5,
          styles:
          const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Profit:',
          width: 7,
          styles: const PosStyles(bold: true)),
      PosColumn(
          text:
          '${ConstantUtil.currencySymbol} ${grossProfit.toStringAsFixed(2)}',
          width: 5,
          styles: const PosStyles(
              bold: true, align: PosAlign.right)),
    ]);

    final margin = totalRevenue > 0
        ? ((grossProfit / totalRevenue) * 100)
        .toStringAsFixed(1)
        : '0.0';

    bytes += generator.row([
      PosColumn(text: 'Margin:', width: 7),
      PosColumn(
          text: '$margin%',
          width: 5,
          styles:
          const PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.hr();
    bytes += generator.text('END OF REPORT',
        styles:
        const PosStyles(align: PosAlign.center));

    bytes += generator.feed(3);
    bytes += generator.cut();

    return bytes;
  }

  // ─────────────────────────────────────────────────────────
  // ── PRINT RECEIPT (main entry point) ─────────────────────
  // ─────────────────────────────────────────────────────────
  Future<void> printReceipt({
    required SaleOrder order,
    required PosTransaction transaction,
    bool isDuplicate = false,
  }) async {
    if (!isConnected) {
      throw Exception(
          'No printer connected. Please connect a printer first.');
    }

    if (_connectionType == 'usb') {
      final bytes = await _buildUsbReceipt(
        order: order,
        transaction: transaction,
        isDuplicate: isDuplicate,
      );

      // 🪟 WINDOWS
      if (Platform.isWindows) {
        if (_windowsPrinterName == null) {
          throw Exception('No Windows USB printer selected');
        }

        await _printWindowsRawData(_windowsPrinterName!, bytes);
      }
      // 📱 ANDROID
      else {
        await _usbPort?.write(Uint8List.fromList(bytes));
      }
    } else if (_connectionType == 'bluetooth' &&
        _bluetoothConnected) {
      final data = _buildBluetoothReceipt(
        order: order,
        transaction: transaction,
        isDuplicate: isDuplicate,
      );
      await _bluetooth.printReceipt({}, data);
    }
  }

  // ─────────────────────────────────────────────────────────
  // ── PRINT REPORT (main entry point) ──────────────────────
  // ─────────────────────────────────────────────────────────
  Future<void> printReport({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required double totalRevenue,
    required double totalCost,
    required double grossProfit,
    required int totalOrders,
    required int totalItems,
  }) async {
    if (!isConnected) {
      throw Exception(
          'No Printer Connected. Please Connect A Printer First.');
    }

    if (_connectionType == 'usb') {
      final bytes = await _buildUsbReport(
        title: title,
        startDate: startDate,
        endDate: endDate,
        totalRevenue: totalRevenue,
        totalCost: totalCost,
        grossProfit: grossProfit,
        totalOrders: totalOrders,
        totalItems: totalItems,
      );

      // 🪟 WINDOWS
      if (Platform.isWindows) {
        if (_windowsPrinterName == null) {
          throw Exception('No Windows USB printer selected');
        }

        await _printWindowsRawData(_windowsPrinterName!, bytes);
      }
      // 📱 ANDROID
      else {
        await _usbPort?.write(Uint8List.fromList(bytes));
      }
    } else if (_connectionType == 'bluetooth' &&
        _bluetoothConnected) {
      // bluetooth report
      final list = <LineText>[];
      final session = SessionManager();
      final fmt = DateFormat('dd/MM/yyyy');

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: session.companyName ?? 'CounterPro',
        align: LineText.ALIGN_CENTER,
        weight: 2,
        linefeed: 1,
      ));
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'SALES REPORT',
        align: LineText.ALIGN_CENTER,
        weight: 1,
        linefeed: 1,
      ));
      list.add(_btDivider());
      list.add(_btRow('From:', fmt.format(startDate)));
      list.add(_btRow('To:', fmt.format(endDate)));
      list.add(_btRow(
          'Printed:',
          DateFormat('dd/MM/yy HH:mm')
              .format(DateTime.now())));
      list.add(_btDivider());
      list.add(_btRow('Orders:', totalOrders.toString()));
      list.add(_btRow('Revenue:',
          '${ConstantUtil.currencySymbol} ${totalRevenue.toStringAsFixed(2)}'));
      list.add(_btRow(
          'Cost:', '${ConstantUtil.currencySymbol} ${totalCost.toStringAsFixed(2)}'));
      list.add(_btRow('Profit:',
          '${ConstantUtil.currencySymbol} ${grossProfit.toStringAsFixed(2)}'));
      list.add(_btDivider());
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'END OF REPORT',
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ));

      await _bluetooth.printReceipt({}, list);
    }
  }

  // ─────────────────────────────────────────────────────────
  // ── HELPERS ───────────────────────────────────────────────
  // ─────────────────────────────────────────────────────────
  String _paymentLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.mobileMoney:
        return 'Mobile Money';
      case PaymentMethod.split:
        return 'Split';
    }
  }

  LineText _btDivider() => LineText(
    type: LineText.TYPE_TEXT,
    content: '--------------------------------',
    linefeed: 1,
  );

  LineText _btDottedLine() => LineText(
    type: LineText.TYPE_TEXT,
    content: '- - - - - - - - - - - - - - - -',
    linefeed: 1,
  );

  LineText _btRow(String label, String value) {
    const width = 32;
    final space = width - label.length - value.length;
    final content = space > 0
        ? '$label${' ' * space}$value'
        : '$label $value';
    return LineText(
      type: LineText.TYPE_TEXT,
      content: content,
      linefeed: 1,
    );
  }
}