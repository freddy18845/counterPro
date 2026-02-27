import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/blocs/screens/home/bloc.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/views/components/shared/inline_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/shared/screen.dart';
import '../../../fragements/home/transaction_card.dart';

class TransactionsSection extends StatefulWidget {
  final HomeBloc homeBloc;
  const TransactionsSection({super.key, required this.homeBloc});

  @override
  State<TransactionsSection> createState() => _TransactionsSectionState();
}

class _TransactionsSectionState extends State<TransactionsSection> {

  @override
  Widget build(BuildContext context) {
    String selectedTransaction = "";
    return Container(
      width: double.infinity,
      height: (ScreenUtil.height * 0.5).clamp(180, 200),
      padding: EdgeInsets.symmetric(
        vertical: ConstantUtil.verticalSpacing,
        horizontal: ConstantUtil.horizontalSpacing,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardOutlineColor,
        // Use .only for specific corner control
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.transactionOptions,
            style: TextStyle(
              fontSize: (ScreenUtil.height * 0.04).clamp(12, 14),
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w900,
              fontFamily: 'Gilroy',
            ),
          ),

          InlineText(title: AppStrings.clickToSelectATransactionOption,),
          SizedBox(height: ConstantUtil.verticalSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: ConstantUtil.options.asMap().entries.map((entry) {
              int index = entry.key;
              var item = entry.value;

              return InkWell(
                onTap: () async {
                  setState(() {
                    selectedTransaction = item.text;
                  });
                 await Future.delayed(const Duration(milliseconds: 100));
                  widget.homeBloc.add(HomeBaseSecStartFlow(item: item));

                },
                child: Expanded(
                  child: TransactionCard(item: item, title: selectedTransaction,)
                      .animate()
                      .fadeIn(
                        delay: Duration(
                          milliseconds: 150 * index,
                        ), // Move the delay INSIDE the effect
                        duration: 500.ms,
                      )
                      .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
