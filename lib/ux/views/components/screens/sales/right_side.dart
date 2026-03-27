import 'package:eswaini_destop_app/ux/models/shared/pos_transaction.dart';
import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:eswaini_destop_app/ux/res/app_theme.dart';
import 'package:eswaini_destop_app/ux/views/components/dialogs/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isar/isar.dart';
import '../../../../../platform/utils/constant.dart';
import '../../../../../platform/utils/isar_manager.dart';
import '../../../../models/shared/sale_order.dart';
import '../../../../models/shared/transaction.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_drawables.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/sessionManager.dart';
import '../../../../utils/shared/app.dart';
import '../../../fragements/shared/short_dash_lines.dart';
import '../../dialogs/payment_dailog.dart';
import '../../shared/btn.dart';
import '../../shared/cart_total_row.dart';
import '../../shared/inline_text.dart';
import '../home/reciept_section.dart';

class SalesCartSection extends StatefulWidget {
  final List cart;
  final double subtotal;
  final double tax;
  final double total;
  final VoidCallback onClear;
  final FocusNode focusNode;
  final Function(int) onRemove;
  final Function(int, int) onUpdateQty;

  const SalesCartSection({
    super.key,
    required this.cart,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.onClear,
    required this.onRemove,
    required this.onUpdateQty,
    required this.focusNode,
  });

  @override
  State<SalesCartSection> createState() => _SalesCartSectionState();
}

class _SalesCartSectionState extends State<SalesCartSection> {
  // ← fixed: @override removed from here, txnId properly declared
  late String txnId;
  final sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    txnId = AppTheme.generateTransactionId(); // ← generate on init
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ── Regenerate txnId for next order ──────────────────────────
  void _regenerateTxnId() {
    setState(() => txnId = AppTheme.generateTransactionId());
  }

  // ── Save order as pending (no payment) ───────────────────────
  Future<void> _handleSave(BuildContext context) async {
    if (widget.cart.isEmpty) return;

    try {
      final isar = IsarService.db;

      await isar.writeTxn(() async {
        final order = SaleOrder()
          ..orderNumber = txnId
          ..status = SaleOrderStatus.saved
          ..items = widget.cart
              .map(
                (item) => SaleItem()
              ..productId = item.product.id
              ..productName = item.product.name
              ..productSku = item.product.sku
              ..barcodeId = item.product.barcodeId
              ..unitPrice = item.product.sellingPrice
              ..costPrice = item.product.costPrice
              ..quantity = item.quantity
              ..discount = 0
              ..totalPrice = item.total,
          )
              .toList()
          ..subtotal = widget.subtotal
          ..discountAmount = 0
          ..taxAmount = widget.tax
          ..totalAmount = widget.total
          ..customerName = null
          ..note = null
          ..createdByUserId = SessionManager().userId ?? 0
          ..createdAt = DateTime.now();
        await isar.saleOrders.put(order);
      });

      if (context.mounted) {
        AppUtil.toastMessage(
          message: '✅ Order saved successfully',
          context: context,
          backgroundColor: Colors.green,
        );
        _regenerateTxnId(); // ← new ID for next order
        widget.onClear();
      }
    } catch (e) {
      if (context.mounted) {
        AppUtil.toastMessage(
          message: '❌ Failed to save order: $e',
          context: context,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  // ── Proceed to payment ────────────────────────────────────────
  Future<void> _handleProceed(BuildContext context) async {
    if (widget.cart.isEmpty) return;
    widget.focusNode.unfocus();
print("pushing  payment daliog");
    final result = await AppUtil.displayDialog(
      context: context,
      dismissible: false,
      child: PaymentDialog(
        total: widget.total,
        subtotal: widget.subtotal,
        tax: widget.tax,
        cart: widget.cart,
        transactionId: txnId,
      ),
    );
    print("done with   payment daliog");
    if (result == true && context.mounted) {
      print("done getting the transaction");
      final isar = IsarService.db;

      final existingTransaction = await isar.posTransactions
          .filter()
          .transactionNumberEqualTo(txnId)
          .findFirst();
      print(" transaction data ${existingTransaction?.id}");
      final existingOrder = await isar.saleOrders
          .filter()
          .orderNumberEqualTo(
          existingTransaction?.orderNumber ?? '')
          .findFirst();
print("working oo ${existingOrder!.totalAmount.toString()}");
print(existingOrder.status.toString());
print(existingOrder.orderNumber.toString());
print(existingOrder.id.toString());
      final data = TransactionData(
        tax: widget.tax,
        total: widget.total,
        dateTime: DateTime.now(),
        subtotal: widget.subtotal,
        txnID: txnId,
        cart: widget.cart,
        transaction: existingTransaction,
        order: existingOrder,
      );

      _regenerateTxnId(); // ← new ID ready for next sale
      widget.focusNode.requestFocus();
      AppNavigator.gotoHome(data, context: context);
      widget.onClear();
    } else {
      // cancelled — restore focus
      widget.focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return leftCardSection(
      sideChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ConstantUtil.verticalSpacing / 4),
          InlineText(title: AppStrings.cart),
          SizedBox(height: ConstantUtil.verticalSpacing / 4),

          // ── Receipt box ───────────────────────────────────
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primaryColor
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  // logo
                  Center(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8),
                      child: SvgPicture.asset(
                        AppDrawables.darkLogoSVG,
                        width: 100,
                        height: 40,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),

                  // company info
                  if (sessionManager.companyName != null)
                    Text(
                      sessionManager.companyName!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (sessionManager.companyAddress != null)
                    Text(
                      sessionManager.companyAddress!,
                      style: const TextStyle(
                          fontSize: 8, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),

                  const SizedBox(height: 4),

                  // cart header
                  if (widget.cart.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Item',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Total',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 4),

                  // cart items
                  Expanded(
                    child: widget.cart.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppDrawables.emptyReceiptSVG,
                            width: 100,
                            height: 40,
                            fit: BoxFit.fitWidth,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Cart is Empty',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                      ),
                    )
                        : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: widget.cart.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: Colors.grey
                            .withValues(alpha: 0.15),
                      ),
                      itemBuilder: (context, index) {
                        final item = widget.cart[index];
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                      style:
                                      const TextStyle(
                                          fontSize: 12),
                                    ),
                                    const SizedBox(
                                        height: 2),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .start,
                                      children: [
                                        _QtyBtn(
                                          icon: Icons.remove,
                                          onTap: () =>
                                              widget
                                                  .onUpdateQty(
                                                index,
                                                item.quantity -
                                                    1,
                                              ),
                                        ),
                                        Container(
                                          width: 22,
                                          padding:
                                          const EdgeInsets
                                              .symmetric(
                                              horizontal:
                                              1),
                                          alignment:
                                          Alignment
                                              .center,
                                          child: Text(
                                            '${item.quantity}',
                                            style:
                                            const TextStyle(
                                                fontSize:
                                                11),
                                          ),
                                        ),
                                        _QtyBtn(
                                          icon: Icons.add,
                                          onTap: () =>
                                              widget
                                                  .onUpdateQty(
                                                index,
                                                item.quantity +
                                                    1,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${ConstantUtil.currencySymbol} ${item.total.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors
                                            .primaryColor,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          widget
                                              .onRemove(index),
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // totals
                  if (widget.cart.isNotEmpty) ...[
                    const DashedLine(),
                    TotalRow(
                      label: AppStrings.subTotal,
                      value:
                      '${ConstantUtil.currencySymbol} ${widget.subtotal.toStringAsFixed(2)}',
                    ),
                    TotalRow(
                      label: AppStrings.tax,
                      value:
                      '${ConstantUtil.currencySymbol} ${widget.tax.toStringAsFixed(2)}',
                    ),
                    TotalRow(
                      label: AppStrings.total, // ← fixed from subTotal
                      value:
                      '${ConstantUtil.currencySymbol} ${widget.total.toStringAsFixed(2)}',
                      isBold: true,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Buttons ───────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Btn(
                  isActive: widget.cart.isNotEmpty,
                  onTap: widget.cart.isEmpty
                      ? () => AppUtil.toastMessage(
                    message:
                    AppStrings.sorryYourCartIsEmpty,
                    context: context,
                    backgroundColor: Colors.grey,
                  )
                      : () async {
                    final res = await AppUtil.displayDialog(
                      dismissible: false,
                      context: context,
                      child: MessageDialog(
                        title: AppStrings.confirmation,
                        message:
                        AppStrings.areYouSureYouWantToSave,
                      ),
                    );
                    if (!context.mounted) return;
                    if (res == true) _handleSave(context);
                  },
                  text: AppStrings.save,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Btn(
                  isActive: widget.cart.isNotEmpty,
                  onTap: widget.cart.isEmpty
                      ? () => AppUtil.toastMessage(
                    message:
                    AppStrings.sorryYourCartIsEmpty,
                    context: context,
                    backgroundColor: Colors.grey,
                  )
                      : () => _handleProceed(context),
                  bgImage: AppDrawables.greenCard,
                  text: AppStrings.proceed,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Btn(
            isActive: widget.cart.isNotEmpty,
            onTap: () async {
              if (widget.cart.isEmpty) return;
              final res = await AppUtil.displayDialog(
                dismissible: false,
                context: context,
                child: MessageDialog(
                  title: AppStrings.confirmation,
                  message: AppStrings.areYouSureYouWantToCart,
                ),
              );
              if (!context.mounted) return;
              if (res == true) {
                _regenerateTxnId(); // ← new ID when cart is cleared
                widget.onClear();
              }
            },
            bgImage: AppDrawables.redCard,
            text: AppStrings.clear,
          ),
        ],
      ),
    );
  }
}

// ── Qty button ────────────────────────────────────────────────
class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 12),
      ),
    );
  }
}