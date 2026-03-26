import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/blocs/screens/home/bloc.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/views/components/shared/inline_text.dart';
import 'package:flutter/material.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/shared/screen.dart';
import '../../../fragements/home/transaction_list.dart';

class TransactionsSection extends StatefulWidget {
  final HomeBloc homeBloc;
  const TransactionsSection({super.key, required this.homeBloc});

  @override
  State<TransactionsSection> createState() => _TransactionsSectionState();
}

class _TransactionsSectionState extends State<TransactionsSection> {
  final bool isDesktop = ScreenUtil.width >= 900;
  @override
  Widget build(BuildContext context) {
    String selectedTransaction = "";
    return Container(
      width: double.infinity,
      height: (ScreenUtil.height * 0.23),
      padding: EdgeInsets.symmetric(horizontal: ConstantUtil.horizontalSpacing),
      decoration: BoxDecoration(
        color: AppColors.cardOutlineColor,
        // Use .only for specific corner control
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InlineText(title: AppStrings.clickToSelectAnOption.toUpperCase()),
          SizedBox(height: ConstantUtil.verticalSpacing / 2),
          isDesktop
              ? ScrollableTransactionsRow(
                  homeBloc: widget.homeBloc,
                  selectedTransaction: selectedTransaction,
                  onSelect: (value) {
                    setState(() {
                      selectedTransaction = value;
                    });
                  },
                )
              : SizedBox(
                  height: 90,
                  child: ScrollableTransactionsRow(
                    homeBloc: widget.homeBloc,
                    selectedTransaction: selectedTransaction,
                    onSelect: (value) {
                      setState(() {
                        selectedTransaction = value;
                      });
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
