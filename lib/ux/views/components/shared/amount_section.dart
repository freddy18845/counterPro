import 'dart:math' as math;

import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/views/components/shared/payment_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Providers/transaction_provider.dart';
import '../../../models/screens/payment/payment_option.dart';
import '../../../models/terminal_sign_on_response.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_strings.dart';
import '../../../utils/shared/app.dart';
import '../../../utils/shared/screen.dart';
import 'amount_feild.dart';
import 'card_widget.dart';
import 'numpad.dart';
import 'dart:async';

class AmountSection extends StatefulWidget {
  final List<PaymentOption> paymentList;
  final String title;
  final String initialAmount;
  final String code;
  final Function(double? value) onTap;
  final Function() onChangeCurrency;

  final Function(PaymentOption item) onPaymentMethod;
  const AmountSection({
    super.key,
    required this.title,
    required this.initialAmount,
    required this.onTap,
    required this.code,
    required this.onPaymentMethod,
    required this.onChangeCurrency,
    required this.paymentList,
  });

  @override
  State<AmountSection> createState() => _AmountSectionState();
}

class _AmountSectionState extends State<AmountSection> {
  late StreamController<Map<dynamic, dynamic>> _amountStreamController;
  final transactionManager = TransactionManager();

  @override
  void initState() {
    super.initState();
    _amountStreamController =
        StreamController<Map<dynamic, dynamic>>.broadcast();
  }

  @override
  void dispose() {
    _amountStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: (ScreenUtil.height * 0.02).clamp(9, 12),
              fontWeight: FontWeight.w900,
              //fontFamily: 'Gilroy',
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Divider(thickness: 1.5, color: AppColors.secondaryColor),
          ),
          SizedBox(height: ConstantUtil.verticalSpacing / 2),
          AmountField(
            initialAmount: double.parse(widget.initialAmount),
            controller: _amountStreamController,
            showSymbol: true,
            selectedCurrency: true,
            currency:
                transactionManager.activeCurrency ??
                transactionManager.currencies.first,
            onChangeCurrency: () {
              widget.onChangeCurrency();
            },
          ),
          SizedBox(height: ConstantUtil.verticalSpacing),
          Expanded(
            child: NumPad(
              limit: 9,
              key: ValueKey(widget.code),
              initialValue: (double.parse(widget.initialAmount) * 100)
                  .toInt()
                  .toString(),
              isAmount: true,
              onInput: (String value) {
                String parsed = AppUtil.parseNumPadAmount(
                  input: value.isEmpty ? "0" : value,
                  decimalPlaces: 2,
                );

                // Update the stream with the new amount
                _amountStreamController.add({
                  'amount': double.parse(parsed),
                  'formatted': parsed,
                });

                // Call the callback
                widget.onTap(double.parse(parsed));
              },
            ),
          ),
          SizedBox(height: ConstantUtil.verticalSpacing / 2),
          Row(
            children: [
              Expanded(
                child: Divider(thickness: 2, color: AppColors.secondaryColor),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  AppStrings.selectAPaymentOption,
                  style: TextStyle(
                    fontSize: (ScreenUtil.height * 0.02).clamp(10, 12),
                    fontWeight: FontWeight.bold,
                    //fontFamily: 'Gilroy',
                  ),
                ),
              ),
              Expanded(
                child: Divider(thickness: 2, color: AppColors.secondaryColor),
              ),
            ],
          ),
          SizedBox(height: ConstantUtil.verticalSpacing),
          LayoutBuilder(
            builder: (context, constraints) {
              const double spacing = 8.0;
              final int cardCount = widget.paymentList.length;
              double cardWidth =
                  (constraints.maxWidth - (spacing * (cardCount - 1))) /
                  cardCount;

              List<Widget> cards = [];

              for (var entry in widget.paymentList.asMap().entries) {
                int index = entry.key;
                var item = entry.value;

                cards.add(
                  PaymentCard(
                    item: item,
                    width: cardWidth,
                    onTap: () {
                      widget.onPaymentMethod(item);
                    },
                  ),
                );
              }

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                alignment: WrapAlignment.start,
                children: cards,
              );
            },
          ),
        ],
      ),
    );
  }
}
