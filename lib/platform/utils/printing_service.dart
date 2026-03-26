import 'dart:convert';
import 'dart:typed_data';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

import 'package:image/image.dart' as img;

class PrinterManager {
  static final PrinterManager _instance = PrinterManager._internal();
  factory PrinterManager() => _instance;
  PrinterManager._internal();

  UsbPort? _usbPort;

  final BluetoothPrint _bluetooth = BluetoothPrint.instance;
  bool _bluetoothConnected = false;

  String _connectionType = ''; // 'usb' or 'bluetooth'

  // ──────────────────────────────
  // 🔌 CONNECT USB
  Future<void> connectUSB() async {
    final devices = await UsbSerial.listDevices();

    if (devices.isEmpty) {
      print('❌ No USB devices found');
      return;
    }

    _usbPort = await devices.first.create();

    if (!await _usbPort!.open()) {
      print('❌ Failed to open USB port');
      return;
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
    print('✅ USB connected');
  }

  // ──────────────────────────────
  // 🔵 CONNECT BLUETOOTH
  Future<void> connectBluetooth(BluetoothDevice device) async {
    bool result = await _bluetooth.connect(device);
    _bluetoothConnected = result;

    if (result) {
      _connectionType = 'bluetooth';
      print('✅ Bluetooth connected');
    } else {
      print('❌ Bluetooth connection failed');
    }
  }

  // ──────────────────────────────
  // 🧾 BUILD USB RECEIPT (ESC/POS)
  Future<List<int>> _buildUsbReceipt({
    required String storeName,
    required String address,
    required List<Map<String, dynamic>> items,
    required double total,
    required double vat,
    required String paymentMethod,
    String? qrData,
    String? barcodeData,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    List<int> bytes = [];

    // Logo
    try {
      final data = await rootBundle.load('assets/logo.png');
      final image = img.decodeImage(data.buffer.asUint8List());
      if (image != null) {
        bytes += generator.image(image, align: PosAlign.center);
      }
    } catch (_) {}

    // Header
    bytes += generator.text(
      storeName,
      styles: PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
      ),
    );

    bytes += generator.text(address,
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.hr();

    // Items
    for (var item in items) {
      bytes += generator.row([
        PosColumn(text: item['name'], width: 6),
        PosColumn(
            text:
            '${item['qty']} x ${item['price'].toStringAsFixed(2)}',
            width: 6),
      ]);
    }

    bytes += generator.hr();

    // Totals
    bytes += generator.text('VAT: ${vat.toStringAsFixed(2)}');

    bytes += generator.text(
      'TOTAL: ${total.toStringAsFixed(2)}',
      styles: PosStyles(bold: true, height: PosTextSize.size2),
    );

    bytes += generator.text('Payment: $paymentMethod');
    bytes += generator.hr();

    if (qrData != null) {
      bytes += generator.qrcode(qrData);
    }

    if (barcodeData != null && barcodeData.isNotEmpty) {
      bytes += generator.barcode(
        Barcode.code128(utf8.encode(barcodeData)),
        width: 2,
        height: 80,
        align: PosAlign.center,
      );
    }

    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }

  // ──────────────────────────────
  // 📡 BUILD BLUETOOTH RECEIPT
  List<LineText> _buildBluetoothReceipt({
    required String storeName,
    required String address,
    required List<Map<String, dynamic>> items,
    required double total,
    required double vat,
    required String paymentMethod,
    String? qrData,
  }) {
    List<LineText> list = [];

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: storeName,
      align: LineText.ALIGN_CENTER,
      weight: 2,
      size: 2,
    ));

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: address,
      align: LineText.ALIGN_CENTER,
    ));

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '-----------------------------',
    ));

    for (var item in items) {
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
        "${item['name']}  ${item['qty']} x ${item['price'].toStringAsFixed(2)}",
      ));
    }

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '-----------------------------',
    ));

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'VAT: ${vat.toStringAsFixed(2)}',
    ));

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'TOTAL: ${total.toStringAsFixed(2)}',
      weight: 2,
      size: 2,
    ));

    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Payment: $paymentMethod',
    ));

    if (qrData != null) {
      list.add(LineText(
        type: LineText.TYPE_QRCODE,
        content: qrData,
        align: LineText.ALIGN_CENTER,
        size: 6,
      ));
    }

    return list;
  }

  // ──────────────────────────────
  // 🖨️ PRINT RECEIPT
  Future<void> printReceipt({
    required String storeName,
    required String address,
    required List<Map<String, dynamic>> items,
    required double total,
    required double vat,
    required String paymentMethod,
    String? qrData,
    String? barcodeData,
  }) async {
    if (_connectionType == 'usb') {
      final bytes = await _buildUsbReceipt(
        storeName: storeName,
        address: address,
        items: items,
        total: total,
        vat: vat,
        paymentMethod: paymentMethod,
        qrData: qrData,
        barcodeData: barcodeData,
      );

      await _usbPort?.write(Uint8List.fromList(bytes));
    } else if (_connectionType == 'bluetooth' &&
        _bluetoothConnected) {
      final data = _buildBluetoothReceipt(
        storeName: storeName,
        address: address,
        items: items,
        total: total,
        vat: vat,
        paymentMethod: paymentMethod,
        qrData: qrData,
      );

      await _bluetooth.printReceipt({}, data);
    } else {
      print('❌ No printer connected');
    }
  }

  // ──────────────────────────────
  // ⚡ AUTO PRINT
  Future<void> autoPrintCheckout({
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
    final vat = total * 0.15;

    await printReceipt(
      storeName: 'CHICKEN SLICE',
      address: 'Accra, Ghana',
      items: items,
      total: total,
      vat: vat,
      paymentMethod: 'CASH',
      qrData: 'https://chickenslice.com',
      barcodeData: '123456789',
    );
  }
}

// //-------------------------Bluetooth auto print --------------
// import 'package:shared_preferences/shared_preferences.dart';
//
// //Save device after connection
// Future<void> savePrinter(BluetoothDevice device) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('printer_address', device.address ?? '');
// }
// //Load & auto reconnect
// Future<void> autoReconnectPrinter() async {
//   final prefs = await SharedPreferences.getInstance();
//   final address = prefs.getString('printer_address');
//
//   if (address == null) return;
//
//   BluetoothPrint.instance.scanResults.listen((devices) async {
//     for (var d in devices) {
//       if (d.address == address) {
//         await PrinterManager().connectBluetooth(d);
//         print("✅ Auto reconnected printer");
//       }
//     }
//   });
//
//   BluetoothPrint.instance.startScan(timeout: Duration(seconds: 3));
// }
// // ✅ AUTO PRINT (optional) after payment
// if (PosSettings.autoPrint) {
// await PrinterManager().autoPrintCheckout(
// items: items,
// total: total,
// );
// }
// //Print Button
// ElevatedButton(
// onPressed: () async {
// await PrinterManager().autoPrintCheckout(
// items: cartItems.map((e) => e.toMap()).toList(),
// total: total,
// );
// },
// child: Text("Print Receipt"),
// )
// Column(
// children: [
// // 🔘 Toggle
// SwitchListTile(
// title: Text("Auto Print"),
// value: PosSettings.autoPrint,
// onChanged: (val) {
// PosSettings.autoPrint = val;
// },
// ),
//
// // 🔍 Scan printer
// ElevatedButton(
// onPressed: scanDevices,
// child: Text("Scan Printer"),
// ),
//
// // 🖨 Print manually
// ElevatedButton(
// onPressed: printTest,
// child: Text("Print Test"),
// ),
//
// // 💳 Checkout
// ElevatedButton(
// onPressed: () => checkout(cartItems),
// child: Text("Checkout"),
// ),
// ],
// )