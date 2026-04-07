import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/platform/utils/isar_manager.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_transaction.dart';
import 'package:eswaini_destop_app/ux/models/shared/product.dart';
import 'package:eswaini_destop_app/ux/models/shared/sale_order.dart';
import 'package:eswaini_destop_app/ux/utils/sessionManager.dart';
import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:flutter/material.dart';
import '../../../models/shared/summary_row.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_strings.dart';
import '../../../utils/shared/screen.dart';
import '../shared/base_dailog.dart';
import '../shared/btn.dart';
import '../shared/login_input.dart';

class PaymentDialog extends StatefulWidget {
  final double total;
  final double subtotal;
  final double tax;
  final List cart;
  final String transactionId;
  final int? existingOrderId; // ← add this

  const PaymentDialog({
    super.key,
    required this.total,
    required this.subtotal,
    required this.tax,
    required this.cart,
    this.existingOrderId, required this.transactionId,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final isar = IsarService.db;
  final _amountController = TextEditingController();
  PaymentMethod _selectedMethod = PaymentMethod.cash;
  bool _isLoading = false;

  double get _amountPaid =>
      double.tryParse(_amountController.text) ?? 0.0;
  double get _change =>
      (_amountPaid - widget.total).clamp(0, double.infinity);
  bool get _canProceed => _amountPaid >= widget.total;

  @override
  void initState() {
    super.initState();
    // pre-fill with exact amount
    _amountController.text = widget.total.toStringAsFixed(2);
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _confirmPayment() async {
    if (!_canProceed) {
      AppUtil.toastMessage(
        message: 'Amount Paid Is Less than Total',
        context: context,
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await isar.writeTxn(() async {
        int orderId;

        if (widget.existingOrderId != null) {
          // ── Resuming a saved order ─────────────────────
          // fetch and update the existing order
          final existing =
          await isar.saleOrders.get(widget.existingOrderId!);
          if (existing != null) {
            existing
              ..status = SaleOrderStatus.completed
              ..completedAt = DateTime.now();
            orderId = await isar.saleOrders.put(existing);
          } else {
            orderId = widget.existingOrderId!;
          }
        } else {
          // ── New order from sales screen ────────────────
          final order = SaleOrder()
            ..orderNumber = widget.transactionId
            ..status = SaleOrderStatus.completed
            ..items = widget.cart
                .map((item) => SaleItem()
              ..productId = item.product.id
              ..productName = item.product.name
              ..productSku = item.product.sku
              ..barcodeId = item.product.barcodeId
              ..unitPrice = item.product.sellingPrice
              ..costPrice = item.product.costPrice
              ..quantity = item.quantity
              ..discount = 0
              ..totalPrice = item.total)
                .toList()
            ..subtotal = widget.subtotal
            ..discountAmount = 0
            ..taxAmount = widget.tax
            ..totalAmount = widget.total
            ..createdByUserId = SessionManager().userId ?? 0
            ..createdAt = DateTime.now()
            ..completedAt = DateTime.now();

          orderId = await isar.saleOrders.put(order);
        }

        // ── Save transaction ───────────────────────────
        final txn = PosTransaction()
          ..transactionNumber = widget.transactionId
          ..saleOrderId = orderId
        // replace the orderNumber line in txn with this
          ..orderNumber = widget.existingOrderId != null
              ? (await isar.saleOrders.get(widget.existingOrderId!))?.orderNumber ??
              widget.transactionId
              : widget.transactionId
          ..paymentMethod = _selectedMethod
          ..status = PosTransactionStatus.completed
          ..amountPaid = _amountPaid
          ..changeGiven = _change
          ..totalAmount = widget.total
          ..processedByUserId = SessionManager().userId ?? 0
          ..timestamp = DateTime.now();

        await isar.posTransactions.put(txn);

        // ── Deduct stock ───────────────────────────────
        for (final item in widget.cart) {
          final product = await isar.products.get(item.product.id);
          if (product != null) {
            product.stockQuantity -= item.quantity as int;
            product.updatedAt = DateTime.now();
            await isar.products.put(product);
          }
        }
      });

      setState(() => _isLoading = false);

      if (mounted) {
        AppUtil.toastMessage(
          message: '✅ Payment successful',
          context: context,
          backgroundColor: Colors.green,
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        AppUtil.toastMessage(
          message: '❌ Payment failed: $e',
          context: context,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context: context);

    return PopScope(
      canPop: false,
      child: DialogBaseLayout(
        title: 'Select Payment Method',
        showCard: true,
        titleSize: 14,
        cardHeight: 420,
        cardWidth: 460,
        onClose: () => Navigator.pop(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),

            // ── Payment method selector ───────────────────
            Row(
              children: PaymentMethod.values.map((method) {
                final isActive = _selectedMethod == method;
                final label = switch (method) {
                  PaymentMethod.cash => 'Cash',
                  PaymentMethod.card => 'Card',
                  PaymentMethod.mobileMoney => 'Mobile Money',
                  PaymentMethod.split => 'Split',
                };
                final icon = switch (method) {
                  PaymentMethod.cash => Icons.payments_outlined,
                  PaymentMethod.card => Icons.credit_card_outlined,
                  PaymentMethod.mobileMoney => Icons.phone_android_outlined,
                  PaymentMethod.split => Icons.call_split_outlined,
                };

                return Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _selectedMethod = method),
                    child:RepaintBoundary(
                      child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primaryColor
                            : Colors.grey.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isActive
                              ? AppColors.primaryColor
                              : Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            size: 22,
                            color: isActive
                                ? Colors.white
                                : Colors.grey,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),)
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // ── Amount paid ───────────────────────────────
            InputField(
              label: 'Amount Paid',
              controller: _amountController,
              hintText: '0.00',
              prexIcon: Icons.attach_money,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
            ),

            const SizedBox(height: 12),

            // ── Summary ───────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                children: [
                  SummaryRow(
                      label: 'Total',
                      value:
                      '${widget.total.toStringAsFixed(2)}'),
                  SummaryRow(
                      label: 'Amount Paid',
                      value:
                      '${_amountPaid.toStringAsFixed(2)}'),
                  const Divider(height: 12),
                  SummaryRow(
                    label: 'Change',
                    value: '${_change.toStringAsFixed(2)}',
                    valueColor: _change > 0
                        ? Colors.green
                        : Colors.black87,
                    isBold: true,
                  ),
                  if (!_canProceed && _amountPaid > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Insufficient amount — need ${ConstantUtil.currencySymbol}${(widget.total - _amountPaid).toStringAsFixed(2)} more',
                        style: const TextStyle(
                            fontSize: 11, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Buttons ───────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: ColorBtn(
                    text: AppStrings.cancel,
                    btnColor: AppColors.red,
                    action: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ColorBtn(
                    text: _isLoading ? 'Processing...' : 'Confirm Payment',
                    btnColor: _canProceed
                        ? AppColors.secondaryColor
                        : Colors.grey,
                    action: _isLoading || !_canProceed
                        ? (){          // ← was () {} which still fires
                      }
                        : _confirmPayment,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Summary row ───────────────────────────────────────────────
