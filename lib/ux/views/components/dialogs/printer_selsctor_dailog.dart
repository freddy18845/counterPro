import 'dart:io';

import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart'  hide PrinterManager;
import '../../../../platform/utils/printing_service.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_strings.dart';

class PrinterSelectorDialog extends StatefulWidget {
  const PrinterSelectorDialog({super.key});

  @override
  State<PrinterSelectorDialog> createState() => _PrinterSelectorDialogState();
}

class _PrinterSelectorDialogState extends State<PrinterSelectorDialog> {
  final PrinterManager _printer = PrinterManager();

  List<PrinterDevice> _usbPrinters = [];
  List<PrinterDevice> _btDevices = [];

  bool _isLoading = false;
  bool _showBluetoothOption = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _autoCheckThermalPrinter();
  }

  Future<void> _autoCheckThermalPrinter() async {
    setState(() => _isLoading = true);

    try {
      // Try auto-select first (picks best thermal automatically)
      final selected = await _printer.autoSelectBestPrinter();
      if (selected != null && mounted) {
        Navigator.pop(context, selected);
        return;
      }


    } catch (e) {
      _error = e.toString();
      AppUtil.toastMessage(message: "$e", context: context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _connectUsbPrinter(PrinterDevice device) async {
    setState(() => _isLoading = true);
    try {
      final success = await _printer.connectUsbPrinter(device);
      if (success && mounted) {
        Navigator.pop(context, {'type': 'usb', 'name': device.name});
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _enableBluetoothMode() {
    setState(() {
      _showBluetoothOption = true;
      _btDevices = [];
    });
    _scanBluetooth();
  }

  void _scanBluetooth() {
    try {
      _printer.scanBluetoothPrinters().listen(
            (device) {
          if (mounted) {
            setState(() {
              // Avoid duplicates
              if (!_btDevices.any((d) => d.address == device.address)) {
                _btDevices.add(device);
              }
            });
          }
        },
        onError: (e) => setState(() => _error = 'Bluetooth scan failed: $e'),
      );
    } catch (e) {
      setState(() => _error = 'Bluetooth scan failed: $e');
    }
  }

  Future<void> _connectBluetooth(PrinterDevice device) async {
    setState(() => _isLoading = true);
    try {
      final success = await _printer.connectBluetoothPrinter(device);
      if (success && mounted) {
        Navigator.pop(context, {'type': 'bluetooth', 'name': device.name});
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- Title Row ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 30),
                const Text(
                  'Printer Setup',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    if (_isLoading) {
                      AppUtil.toastMessage(
                        message: 'Please wait, searching for printer...',
                        context: context,
                      );
                      return;
                    }
                    _printer.disconnect();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.red),
                ),
              ],
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 20),

            // ---- States ----
            if (_isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Searching for printer...'),
                ],
              )

            else if (_usbPrinters.isNotEmpty) ...[
              const Text(
                'Found Printers',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ..._usbPrinters.map(
                    (device) => ListTile(
                  leading: const Icon(Icons.print, color: Colors.orange),
                  title: Text(device.name ?? 'Unknown Printer'),
                  subtitle: Text(device.productId ?? ''),
                  onTap: () => _connectUsbPrinter(device),
                ),
              ),
              const SizedBox(height: 12),
              // Allow switching to Bluetooth even if USB found
              TextButton.icon(
                onPressed: _enableBluetoothMode,
                icon: const Icon(Icons.bluetooth),
                label: const Text('Use Bluetooth instead'),
              ),
            ]

            else if (!_showBluetoothOption) ...[
                const Icon(Icons.print_disabled, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No printer detected',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Would you like to use a Bluetooth printer instead?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.cancel,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _enableBluetoothMode,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.green,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.useBluetooth,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]

              else ...[
                  const Text(
                    'Bluetooth Printers',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  if (_btDevices.isEmpty)
                    const Column(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(height: 12),
                        Text('Scanning for Bluetooth printers...'),
                      ],
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _btDevices.length,
                      itemBuilder: (context, index) {
                        final device = _btDevices[index];
                        return ListTile(
                          leading: const Icon(Icons.bluetooth, color: Colors.blue),
                          title: Text(device.name ?? 'Unknown'),
                          subtitle: Text(device.address ?? ''),
                          onTap: () => _connectBluetooth(device),
                        );
                      },
                    ),
                ],

            // ---- Error ----
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}