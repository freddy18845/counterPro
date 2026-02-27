
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/screens/withdrawal/bloc.dart';
import '../../../../blocs/screens/withdrawal/event.dart';
import '../../../../models/screens/payment/payment_option.dart';
import '../../../../res/app_strings.dart';
import '../../shared/amount_section.dart';

class WithdrawalAmountSection extends StatelessWidget {
  final WithdrawalBloc bloc;

  const WithdrawalAmountSection({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WithdrawalBloc, WithdrawalState>(
      bloc: bloc,
      builder: (context, state) {
        final amount = bloc.metaData.amount;

        return AmountSection(
          title: AppStrings.withdrawal,
          initialAmount: amount.toString(),
          paymentList: bloc.metaData.paymentOption,
          code: bloc.metaData.currency.code,
          onTap: (double? value) {
            // WithdrawalSetPaymentTypeEvent
            bloc.add(
              WithdrawalSetAmountEvent(amount: value ?? 0),
            );
          }, onPaymentMethod: (PaymentOption value) {
            bloc.add(WithdrawalSetPaymentTypeEvent(selectedPaymentOption: value));
        }, onChangeCurrency: () {
          bloc.add(
            WithdrawalPromptCurrencyEvent(),
          );
        },
        );
      },
    );
  }
}
