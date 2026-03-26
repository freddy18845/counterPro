import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:eswaini_destop_app/ux/res/app_theme.dart';
import 'package:eswaini_destop_app/ux/views/components/dialogs/message.dart';
import 'package:eswaini_destop_app/ux/views/fragements/shared/short_dash_lines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../../platform/utils/constant.dart';
import '../../../../../platform/utils/isar_manager.dart';
import '../../../../models/shared/sale_order.dart';
import '../../../../models/shared/transaction.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_drawables.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/sessionManager.dart';
import '../../../../utils/shared/app.dart';
import '../../../../utils/shared/screen.dart';
import '../../dialogs/logout.dart';
import '../../dialogs/payment_dailog.dart';
import '../../shared/btn.dart';
import '../../shared/cart_total_row.dart';
import '../../shared/inline_text.dart';
import '../../shared/receipt_item.dart';
import '../home/reciept_section.dart';

class HomeRightSection extends StatelessWidget {
  final TransactionData? transactionData;

  const HomeRightSection({
    super.key,
    this.transactionData,
  });

  @override
  Widget build(BuildContext context) {
    final sessionManager = SessionManager();

    /// ✅ SAFE DATA EXTRACTION
    final cart = transactionData?.cart ?? [];
    final total = transactionData?.total ?? 0.0;
    final subtotal = transactionData?.subtotal ?? 0.0;
    final tax = transactionData?.tax ?? 0.0;
    final txnID = transactionData?.txnID ?? '';
    final dateTime = transactionData?.dateTime;

    return leftCardSection(
      sideChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.receiptHistory,
            style: TextStyle(
              fontSize: (ScreenUtil.height * 0.025).clamp(12, 14),
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              AppStrings.previewReceipt,
              style: TextStyle(
                fontSize: (ScreenUtil.height * 0.02).clamp(9, 10),
                fontFamily: 'Gilroy',
              ),
            ),
          ),

          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(AppDrawables.receipt),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  /// LOGO
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SvgPicture.asset(
                        AppDrawables.darkLogoSVG,
                        width: 80,
                        height: 30,
                      ),
                    ),
                  ),

                  /// COMPANY INFO
                  if (sessionManager.companyName != null)
                    Text(
                      sessionManager.companyName!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                  if (sessionManager.companyAddress != null)
                    Text(
                      sessionManager.companyAddress!,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 3),
                  const DashedLine() ,
                  const SizedBox(height: 2),

                  /// RECEIPT META
                  ReceiptItem(
                    index: AppStrings.teller,
                    value: sessionManager.currentUser?.name ?? '',
                  ),
                  ReceiptItem(
                    index: AppStrings.dateTime,
                    value: dateTime != null
                        ? DateFormat('yyyy-MM-dd HH:mm')
                        .format(dateTime)
                        : DateFormat('yyyy-MM-dd HH:mm')
                        .format(DateTime.now()),
                  ),
                  ReceiptItem(
                    index: AppStrings.transactionId,
                    value: txnID.isNotEmpty?txnID:'TXN-0000000',
                  ),

                  cart.isNotEmpty?SizedBox(height: 8,): Container(
                    margin: EdgeInsets.only(top: 2),
                    child: DashedLine(),
                  ),

                  /// CART HEADER
                  if (cart.isNotEmpty)
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
                              'Qty',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
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

                  /// CART ITEMS
                  Expanded(
                    child: cart.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppDrawables.emptyReceiptSVG,
                            width: 100,
                            height: 40,
                          ),
                          const SizedBox(height: 16),
                          const Text(
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
                      itemCount: cart.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: Colors.grey
                            .withValues(alpha: 0.15),
                      ),
                      itemBuilder: (context, index) {
                        final item = cart[index];
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(
                              vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(

                                  item.product?.name ?? '',
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          Expanded(
                            child:   Text(
                              textAlign: TextAlign.right,
                                '${(item.total ?? 0).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color:
                                  AppColors.primaryColor,
                                ),
                              ),)
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  /// TOTALS
                  if (cart.isNotEmpty) ...[
                    Divider(
                        color: Colors.grey
                            .withValues(alpha: 0.3)),
                    TotalRow(
                      label: AppStrings.subTotal,
                      value:
                      '${ConstantUtil.currencySymbol} ${subtotal.toStringAsFixed(2)}',
                    ),
                    TotalRow(
                      label: AppStrings.tax,
                      value:
                      '${ConstantUtil.currencySymbol} ${tax.toStringAsFixed(2)}',
                    ),
                    TotalRow(
                      label: AppStrings.total,
                      value:
                      '${ConstantUtil.currencySymbol} ${total.toStringAsFixed(2)}',
                      isBold: true,
                    ),
                    SizedBox(height: ScreenUtil.height * 0.035,)
                  ],
                ],
              ),
            ),
          ),

          /// PRINT BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Btn(
              isActive: cart.isNotEmpty,
              bgImage: AppDrawables.blueCard,
              text: AppStrings.print,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}