import 'package:eswaini_destop_app/ux/views/components/dialogs/printer_selsctor_dailog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../platform/utils/printing_service.dart';
import '../../../models/shared/pos_transaction.dart';
import '../../../models/shared/sale_order.dart';
import '../../../res/app_colors.dart';
import '../shared/btn.dart';

class PrintConfirmDialog extends StatefulWidget {
  final SaleOrder order;
  final PosTransaction transaction;

  const PrintConfirmDialog({
    required this.order,
    required this.transaction,
  });

  @override
  State<PrintConfirmDialog> createState() =>
      _PrintConfirmDialogState();
}

class _PrintConfirmDialogState
    extends State<PrintConfirmDialog> {
  bool _isPrinting = false;
  final _printer = PrinterManager();

  Future<void> _print({bool isDuplicate = false}) async {
    if (!_printer.isConnected) {
      // show printer selector first
      final result = await showDialog(
        context: context,
        builder: (_) => const PrinterSelectorDialog(),
      );
      if (result == null) return;
    }

    setState(() => _isPrinting = true);
    try {
      await _printer.printReceipt(
        order: widget.order,
        transaction: widget.transaction,
        isDuplicate: isDuplicate,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Print failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                color: Colors.green, size: 48),
            const SizedBox(height: 12),
            const Text('Payment Successful!',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              'Order: ${widget.order.orderNumber}',
              style: const TextStyle(
                  fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ColorBtn(
                    text: _isPrinting
                        ? 'Printing...'
                        : '🖨 Print Receipt',
                    btnColor: AppColors.primaryColor,
                    action: _isPrinting
                        ? (){}
                        : () => _print(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ColorBtn(
                    text: 'Skip',
                    btnColor: Colors.grey,
                    action: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}