
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import '../../../../platform/utils/printing_service.dart';
import '../../../res/app_colors.dart';


class PrinterSelectorDialog extends StatefulWidget {
  const PrinterSelectorDialog({super.key});

  @override
  State<PrinterSelectorDialog> createState() =>
      _PrinterSelectorDialogState();
}

class _PrinterSelectorDialogState
    extends State<PrinterSelectorDialog> {
  final _printer = PrinterManager();
  final _bluetooth = BluetoothPrint.instance;

  List<BluetoothDevice> _devices = [];
  bool _isScanning = false;
  String? _connectingAddress;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scan();
  }

  Future<void> _scan() async {
    setState(() {
      _isScanning = true;
      _devices = [];
      _error = null;
    });

    try {
      _bluetooth.scanResults.listen((results) {
        if (mounted) setState(() => _devices = results);
      });
      await _bluetooth.startScan(
          timeout: const Duration(seconds: 5));
    } catch (e) {
      setState(() => _error = 'Scan failed: $e');
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _connectUSB() async {
    setState(() => _connectingAddress = 'usb');
    try {
      final success = await _printer.connectUSB();
      if (success && mounted) {
        Navigator.pop(context, 'usb');
      } else {
        setState(() => _error = 'No USB printer found');
      }
    } catch (e) {
      setState(() => _error = 'USB error: $e');
    } finally {
      setState(() => _connectingAddress = null);
    }
  }

  Future<void> _connectBluetooth(
      BluetoothDevice device) async {
    setState(
            () => _connectingAddress = device.address);
    try {
      final success =
      await _printer.connectBluetooth(device);
      if (success && mounted) {
        Navigator.pop(context, device.address);
      } else {
        setState(() =>
        _error = 'Could not connect to ${device.name}');
      }
    } catch (e) {
      setState(() => _error = 'Connect error: $e');
    } finally {
      if (mounted) {
        setState(() => _connectingAddress = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text('Connect Printer',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor)),
                Row(
                  children: [
                    if (_isScanning)
                      const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2))
                    else
                      GestureDetector(
                        onTap: _scan,
                        child: Icon(Icons.refresh,
                            size: 20,
                            color: AppColors.primaryColor),
                      ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close,
                          size: 20),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // USB option
            GestureDetector(
              onTap: _connectingAddress == 'usb'
                  ? null
                  : _connectUSB,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange
                      .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.orange
                          .withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.usb_outlined,
                        color: Colors.orange, size: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text('USB Printer',
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 13)),
                          Text(
                              'Connect via USB cable',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                    _connectingAddress == 'usb'
                        ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                        CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.orange))
                        : const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // bluetooth section
            const Text('Bluetooth Printers',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black87)),
            const SizedBox(height: 8),

            if (_error != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(_error!,
                    style: const TextStyle(
                        color: Colors.red, fontSize: 12)),
              ),

            if (_isScanning && _devices.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                          strokeWidth: 2),
                      SizedBox(height: 8),
                      Text('Scanning...',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12)),
                    ],
                  ),
                ),
              )
            else if (!_isScanning && _devices.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.bluetooth_disabled,
                          size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('No devices found',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12)),
                      Text(
                          'Make sure printer is on & paired',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11)),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  final device = _devices[index];
                  final isConnecting =
                      _connectingAddress ==
                          device.address;

                  return GestureDetector(
                    onTap: isConnecting
                        ? null
                        : () =>
                        _connectBluetooth(device),
                    child: Container(
                      margin:
                      const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue
                            .withValues(alpha: 0.06),
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.blue
                                .withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                              Icons.print_outlined,
                              color: Colors.blue,
                              size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  device.name ??
                                      'Unknown',
                                  style: const TextStyle(
                                      fontWeight:
                                      FontWeight.w600,
                                      fontSize: 13),
                                ),
                                Text(
                                  device.address ?? '',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          isConnecting
                              ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                              CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color:
                                  Colors.blue))
                              : const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}