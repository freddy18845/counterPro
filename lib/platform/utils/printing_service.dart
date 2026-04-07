import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ux/models/shared/sale_order.dart';
import '../../ux/models/shared/pos_transaction.dart';
import '../../ux/utils/sessionManager.dart';
import 'constant.dart';

class PrinterManager {
  static final PrinterManager _instance = PrinterManager._internal();
  factory PrinterManager() => _instance;
  PrinterManager._internal();

  // Windows USB Channel
  static const MethodChannel _windowsChannel = MethodChannel('usb_printer_windows');

  // Bluetooth
  final BluetoothPrint _bluetooth = BluetoothPrint.instance;

  String? _windowsPrinterName;
  bool _bluetoothConnected = false;
  BluetoothDevice? _connectedBluetoothDevice;

  String _connectionType = ''; // 'usb' or 'bluetooth'

  bool get isConnected => _connectionType.isNotEmpty;
  String get connectionType => _connectionType;

  /// Auto select best printer (Thermal USB first)
  Future<Map<String, dynamic>?> autoSelectBestPrinter() async {
    // 1. Windows Thermal Printer First (Priority)
    if (Platform.isWindows) {
      final printers = await getWindowsPrinters();

      if (printers.isNotEmpty) {
        // Try to find best thermal printer
        String? bestPrinter = _findBestThermalPrinter(printers);

        if (bestPrinter != null) {
          await connectWindowsPrinter(bestPrinter);
          print('✅ Auto-selected Thermal Printer: $bestPrinter');
          return {'type': 'usb', 'name': bestPrinter};
        } else if (printers.isNotEmpty) {
          // Use first printer if no clear thermal found
          await connectWindowsPrinter(printers.first);
          print('✅ Auto-selected Windows Printer: ${printers.first}');
          return {'type': 'usb', 'name': printers.first};
        }
      }
    }

    // 2. Fallback to Bluetooth (only on mobile)
    if (Platform.isAndroid || Platform.isIOS) {
      print('ℹ️ No Windows printer found, falling back to Bluetooth...');
      // You can auto scan here if you want
    }

    return null;
  }

  /// Helper: Try to detect thermal printer by name
  String? _findBestThermalPrinter(List<String> printers) {
    final thermalKeywords = [
      'POS', 'Thermal', 'TM-T', 'Epson', 'Star', '58mm', '80mm',
      'Receipt', 'Printer-Pos', 'XP', 'TP'
    ];

    for (var printer in printers) {
      final name = printer.toUpperCase();
      if (thermalKeywords.any((keyword) => name.contains(keyword))) {
        return printer;
      }
    }
    return null;
  }

  /// Check if we have a connected thermal printer
  bool get hasThermalPrinter => _connectionType == 'usb' && _windowsPrinterName != null;
  // ====================== WINDOWS USB ======================
  Future<List<String>> getWindowsPrinters() async {
    try {
      final List<dynamic> result = await _windowsChannel.invokeMethod('getPrinters');
      return result.cast<String>();
    } catch (e) {
      print('❌ Failed to get Windows printers: $e');
      return [];
    }
  }

  Future<bool> connectWindowsPrinter(String printerName) async {
    _windowsPrinterName = printerName;
    _connectionType = 'usb';
    _bluetoothConnected = false;
    print('✅ Connected to Windows Printer: $printerName');
    return true;
  }

  // ====================== BLUETOOTH ======================
  Future<bool> connectBluetooth(BluetoothDevice device) async {
    try {
      final success = await _bluetooth.connect(device);
      if (success) {
        _bluetoothConnected = true;
        _connectedBluetoothDevice = device;
        _connectionType = 'bluetooth';
        _windowsPrinterName = null;

        // Save for auto-reconnect
        await _savePrinterAddress(device.address ?? '');
        print('✅ Bluetooth connected: ${device.name}');
      }
      return success;
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

    final bytes = await _buildEscPosReceipt(order: order, transaction: transaction, isDuplicate: isDuplicate);

    if (_connectionType == 'usb' && Platform.isWindows) {
      final success = await _printWindowsRaw(bytes);
      if (!success) throw Exception('Failed to print on Windows');
    } else if (_connectionType == 'bluetooth' && _bluetoothConnected) {
      final list = _buildBluetoothReceipt(order: order, transaction: transaction, isDuplicate: isDuplicate);
      await _bluetooth.printReceipt({}, list);
    }
  }

  Future<bool> _printWindowsRaw(List<int> bytes) async {
    if (_windowsPrinterName == null) return false;
    try {
      final success = await _windowsChannel.invokeMethod('printBytes', {
        'printerName': _windowsPrinterName,
        'bytes': bytes,
      });
      return success == true;
    } catch (e) {
      print('Windows print error: $e');
      return false;
    }
  }

  // Build ESC/POS Receipt (USB)
  Future<List<int>> _buildEscPosReceipt({
    required SaleOrder order,
    required PosTransaction transaction,
    bool isDuplicate = false,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final session = SessionManager();

    List<int> bytes = [];

    // Header, Items, Total, etc. (You can expand this)
    bytes += generator.text(
      session.companyName ?? 'CounterPro',
      styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
    );

    bytes += generator.feed(3);
    bytes += generator.cut();

    return bytes;
  }

  // Build Bluetooth Receipt
  List<LineText> _buildBluetoothReceipt({
    required SaleOrder order,
    required PosTransaction transaction,
    bool isDuplicate = false,
  }) {
    // ... your existing bluetooth receipt logic
    final list = <LineText>[];
    // Add your receipt lines here
    return list;
  }

  // Save / Load Printer Address
  Future<void> _savePrinterAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_printer', address);
  }

  // Disconnect
  Future<void> disconnect() async {
    if (_connectionType == 'bluetooth') {
      await _bluetooth.disconnect();
      _bluetoothConnected = false;
    }
    _connectionType = '';
    _windowsPrinterName = null;
    _connectedBluetoothDevice = null;
  }
}