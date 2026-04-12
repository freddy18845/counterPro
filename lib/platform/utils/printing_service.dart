import 'dart:io';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart' as pos_printer;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ux/models/shared/sale_order.dart';
import '../../ux/models/shared/pos_transaction.dart';
import '../../ux/utils/sessionManager.dart';
import 'constant.dart';

class PrinterManager {
  static final PrinterManager _instance = PrinterManager._internal();
  factory PrinterManager() => _instance;
  PrinterManager._internal();

  // ✅ Correctly references the package, not this file
  final _posPrinter = pos_printer.PrinterManager.instance;

  pos_printer.PrinterDevice? _connectedDevice;
  pos_printer.PrinterType? _printerType;

  bool get isConnected => _connectedDevice != null;
  String get connectionType => _printerType == pos_printer.PrinterType.usb
      ? 'usb'
      : _printerType == pos_printer.PrinterType.bluetooth
      ? 'bluetooth'
      : '';

  bool get hasThermalPrinter =>
      _printerType == pos_printer.PrinterType.usb && _connectedDevice != null;

  // ====================== DISCOVERY ======================

  Future<List<pos_printer.PrinterDevice>> getUsbPrinters() async {
    try {
      final printers = <pos_printer.PrinterDevice>[];
      await for (final device
      in _posPrinter.discovery(type: pos_printer.PrinterType.usb)) {
        printers.add(device);
      }
      return printers;
    } catch (e) {
      print('❌ Failed to get USB printers: $e');
      return [];
    }
  }

  Stream<pos_printer.PrinterDevice> scanBluetoothPrinters() {
    return _posPrinter.discovery(type: pos_printer.PrinterType.bluetooth);
  }

  // ====================== AUTO SELECT ======================
  Future<Map<String, dynamic>?> autoSelectBestPrinter() async {
    // 1. Try USB first on ALL platforms
    try {
      final printers = await getUsbPrinters(); // works on Android/Windows/Linux too
      if (printers.isNotEmpty) {
        final best = _findBestThermalPrinter(printers);
        final selected = best ?? printers.first;
        await connectUsbPrinter(selected);
        print('✅ Auto-selected USB Printer: ${selected.name}');
        return {'type': 'usb', 'name': selected.name};
      }
    } catch (e) {
      print('⚠️ USB discovery failed: $e');
    }

    // 2. Fallback to Bluetooth on all platforms
    print('ℹ️ No USB printer found, falling back to Bluetooth...');
    return null;
  }

  pos_printer.PrinterDevice? _findBestThermalPrinter(
      List<pos_printer.PrinterDevice> printers) {
    const thermalKeywords = [
      'POS', 'THERMAL', 'TM-T', 'EPSON', 'STAR',
      '58MM', '80MM', 'RECEIPT', 'PRINTER-POS', 'XP', 'TP',
    ];
    for (final device in printers) {
      final name = (device.name ?? '').toUpperCase();
      if (thermalKeywords.any((k) => name.contains(k))) return device;
    }
    return null;
  }

  // ====================== CONNECT ======================

  Future<bool> connectUsbPrinter(pos_printer.PrinterDevice device) async {
    try {
      await _posPrinter.connect(
        type: pos_printer.PrinterType.usb,
        model: pos_printer.UsbPrinterInput(
          name: device.name ?? '',
          productId: device.productId,
          vendorId: device.vendorId,
        ),
      );
      _connectedDevice = device;
      _printerType = pos_printer.PrinterType.usb;
      print('✅ Connected to USB Printer: ${device.name}');
      return true;
    } catch (e) {
      print('❌ USB connect error: $e');
      return false;
    }
  }

  Future<bool> connectBluetoothPrinter(pos_printer.PrinterDevice device) async {
    try {
      await _posPrinter.connect(
        type: pos_printer.PrinterType.bluetooth,
        model: pos_printer.BluetoothPrinterInput(
          name: device.name ?? '',
          address: device.address ?? '',
          isBle: false,
          autoConnect: false,
        ),
      );
      _connectedDevice = device;
      _printerType = pos_printer.PrinterType.bluetooth;
      await _savePrinterAddress(device.address ?? '');
      print('✅ Connected to Bluetooth Printer: ${device.name}');
      return true;
    } catch (e) {
      print('❌ Bluetooth connect error: $e');
      return false;
    }
  }

  // ====================== PRINTING ======================

  Future<void> printReceipt({
    required SaleOrder order,
    required PosTransaction transaction,
    bool isDuplicate = false,
  }) async {
    if (!isConnected) throw Exception('No printer connected');

    final bytes = await _buildEscPosReceipt(
      order: order,
      transaction: transaction,
      isDuplicate: isDuplicate,
    );

    await _posPrinter.send(type: _printerType!, bytes: bytes);
    print('✅ Receipt printed successfully');
  }

  Future<List<int>> _buildEscPosReceipt({
    required SaleOrder order,
    required PosTransaction transaction,
    bool isDuplicate = false,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final session = SessionManager();

    List<int> bytes = [];

    bytes += generator.text(
      session.companyName ?? 'CounterPro',
      styles: const PosStyles(
          align: PosAlign.center, bold: true, height: PosTextSize.size2),
    );

    if (isDuplicate) {
      bytes += generator.text(
        '*** DUPLICATE ***',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
    }

    bytes += generator.hr();

    for (final item in order.items) {
      bytes += generator.row([
        PosColumn(text: item.productName, width: 7),
        PosColumn(text: item.unitPrice.toString(), width: 5,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes += generator.hr();

     bytes += generator.row([
      PosColumn(text: 'TOTAL', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: transaction.amountPaid.toString(), width: 6,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    bytes += generator.feed(3);
    bytes += generator.cut();

    return bytes;
  }

  // ====================== HELPERS ======================

  Future<void> _savePrinterAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_printer', address);
  }

  Future<void> disconnect() async {
    try {
      if (_printerType != null) {
        await _posPrinter.disconnect(type: _printerType!);
      }
    } catch (e) {
      print('Disconnect error: $e');
    } finally {
      _connectedDevice = null;
      _printerType = null;
    }
  }
}