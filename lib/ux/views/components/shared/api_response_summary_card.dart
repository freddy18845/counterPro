import 'package:eswaini_destop_app/ux/models/screens/home/flow_item.dart';
import 'package:eswaini_destop_app/ux/res/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../platform/utils/constant.dart';
import '../../../../platform/utils/utils.dart';
import '../../../models/shared/transaction.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_strings.dart';
import '../../../utils/shared/screen.dart';
import '../../fragements/shared/short_dash_lines.dart';
import 'amount_to_pay.dart';
import 'currency_selection.dart';

class ApiResponseSummaryCard extends StatelessWidget {
  final HomeFlowItem metaData;
  final TransactionData transactionData;
  const ApiResponseSummaryCard({
    super.key,
    required this.metaData,
    required this.transactionData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ConstantUtil.horizontalSpacing * 2,
      ),
      child:
          Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: ConstantUtil.verticalSpacing * 2),
                  Text(
                    AppStrings.transactionAmount,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: (ScreenUtil.height * 0.02).clamp(10, 14),
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Gilroy',
                    ),
                  ),
                  SizedBox(height: ConstantUtil.verticalSpacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: ConstantUtil.verticalSpacing,
                        ),
                        child: CurrencySelectorButton(
                          isSingleCurrency: true,
                          symbol: metaData.currency.symbol ?? "",
                          color: transactionData.approved == '00'
                              ? AppColors.green
                              : AppColors.red,
                          onTap: () => null,
                        ),
                      ),
                      SizedBox(width: 8), // Add spacing

                      AmountToPay(
                        amount: metaData.amount,
                        symbol: metaData.currency.symbol ?? "",
                        decimals:
                            int.tryParse(metaData.currency.precision) ?? 2,
                        scaleFactor: 2.0,
                        color: transactionData.approved == '00'
                            ? AppColors.green
                            : AppColors.red,
                      ),
                    ],
                  ),

                  SizedBox(height: ConstantUtil.verticalSpacing),
                  DashedLine(
                    height: 1.5,
                    color: Colors.black,
                    dashWidth: 2,
                    dashSpace: 3,
                  ),
                  AppTheme.buildDetailRow(
                    AppStrings.transactionType,
                    metaData.text,
                  ),

                  AppTheme.buildDetailRow(
                    metaData.paymentType.label,
                    getTransactionAccountOrPan(data: metaData),
                  ),
                  AppTheme.buildDetailRow(
                    AppStrings.dateTime,
                    transactionData.dateTime ?? 'N/A',
                  ),
                  AppTheme.buildDetailRow(
                    AppStrings.authCode,
                    transactionData.authorizationCode ?? 'N/A',
                  ),
                  Divider(thickness: 0.8, color: Colors.black),
                  Text(
                    transactionData.authorizationReference ?? 'N/A',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: (ScreenUtil.height * 0.02).clamp(10, 12),
                      fontWeight: FontWeight.w900,
                      //fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              )
              .animate(
                onPlay: (controller) => controller.forward(), // Only play once
                autoPlay: true,
              )
              .fadeIn(begin: 0.0, duration: 200.ms, curve: Curves.easeIn)
              .slideY(
                begin:
                    -0.25, // Small slide from above (negative value slides from top)
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              )
              .then(delay: 100.ms) // Wait a bit before the bounce
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1.0, 1.0),
                duration: 1000.ms,
                curve: Curves.elasticOut,
              ),
    );
  }
}
