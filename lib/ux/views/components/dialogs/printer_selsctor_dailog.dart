import 'dart:io';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:flutter/material.dart';
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

  List<String> _windowsPrinters = [];
  List<BluetoothDevice> _btDevices = [];

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
      final selected = await _printer.autoSelectBestPrinter();
      if (selected != null && mounted) {
        Navigator.pop(context, selected);
        return;
      }

      // No thermal printer found
      if (Platform.isWindows) {
        _windowsPrinters = await _printer.getWindowsPrinters();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _connectWindowsPrinter(String name) async {
    final success = await _printer.connectWindowsPrinter(name);
    if (success && mounted) {
      Navigator.pop(context, {'type': 'usb', 'name': name});
    }
  }

  void _enableBluetoothMode() {
    setState(() => _showBluetoothOption = true);
    if (Platform.isAndroid || Platform.isIOS) {
      _scanBluetooth();
    }
  }

  Future<void> _scanBluetooth() async {
    // Your existing scan logic...
    try {
      final bluetooth = BluetoothPrint.instance;
      bluetooth.scanResults.listen((results) {
        if (mounted) setState(() => _btDevices = results);
      });
      await bluetooth.startScan(timeout: const Duration(seconds: 6));
    } catch (e) {
      setState(() => _error = 'Bluetooth scan failed');
    }
  }

  Future<void> _connectBluetooth(BluetoothDevice device) async {
    final success = await _printer.connectBluetooth(device);
    if (success && mounted) {
      Navigator.pop(context, {'type': 'bluetooth', 'device': device});
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
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               SizedBox(width: 30,),
               const Text('Printer Setup',
                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

               IconButton(onPressed: (){
                 if (_isLoading){
                   AppUtil.toastMessage(message: "Please Wait,Searching for thermal Printer...", context: context);
                   return;
                 }
                 PrinterManager().disconnect();
                 Navigator.pop(context);
               }, icon: Icon(Icons.close, color: Colors.red,))
             ],
           ),
            Divider(thickness: 1,),
            const SizedBox(height: 20),

            if (_isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Searching for thermal Printer...'),
                ],
              )

            else if (_windowsPrinters.isNotEmpty) ...[
              // Show found Windows printers
              const Text('Found Printers', style: TextStyle(fontWeight: FontWeight.w600)),
              ..._windowsPrinters.map((name) => ListTile(
                leading: const Icon(Icons.print, color: Colors.orange),
                title: Text(name),
                onTap: () => _connectWindowsPrinter(name),
              )),
            ]

            else if (!_showBluetoothOption) ...[
                // No thermal printer found
                const Icon(Icons.print_disabled, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No thermal printer detected',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Would you like to use Bluetooth printer instead?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  spacing: 12,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.cancel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Proceed Button
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedOpacity(
                        opacity:  1.0 ,
                        duration: Duration(milliseconds: 300),
                        child: GestureDetector(
                          onTap:_enableBluetoothMode,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.green,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.useBluetooth,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ]

              else ...[
                  // Bluetooth Mode
                  const Text('Bluetooth Printers', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  if (_btDevices.isEmpty)
                    const Text('Scanning for Bluetooth printers...')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _btDevices.length,
                      itemBuilder: (context, index) {
                        final device = _btDevices[index];
                        return ListTile(
                          leading: const Icon(Icons.bluetooth),
                          title: Text(device.name ?? 'Unknown'),
                          subtitle: Text(device.address ?? ''),
                          onTap: () => _connectBluetooth(device),
                        );
                      },
                    ),
                ],

            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}