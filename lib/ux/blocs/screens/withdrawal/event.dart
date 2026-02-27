import 'package:eswaini_destop_app/ux/models/screens/home/flow_item.dart';
import 'package:eswaini_destop_app/ux/models/shared/wallet/network.dart';

import '../../../models/screens/payment/payment_option.dart';
import '../../../models/shared/progress/info.dart';
import '../../../models/terminal_sign_on_response.dart';

sealed class WithdrawalEvent {}

final class WithdrawalGoBackEvent extends WithdrawalEvent {}

final class WithdrawalExitEvent extends WithdrawalEvent {}


final class WithdrawalPromptCurrencyEvent extends WithdrawalEvent {}

final class WithdrawalSetPaymentTypeEvent extends WithdrawalEvent {
  final PaymentOption selectedPaymentOption;
  WithdrawalSetPaymentTypeEvent({required this.selectedPaymentOption});
}

final class WithdrawalSetCurrencyEvent extends WithdrawalEvent {
  final Currency? data;

  WithdrawalSetCurrencyEvent({required this.data});
}

final class WithdrawalSetAmountEvent extends WithdrawalEvent {
  final double amount;

  WithdrawalSetAmountEvent({required this.amount});
}
final class WithdrawalWalletSelectedEvent extends WithdrawalEvent {
  final WalletNetwork network;

  WithdrawalWalletSelectedEvent({required this.network});
}

final class WithdrawalProgressResEvent extends WithdrawalEvent {
  final HomeFlowItem data;

  WithdrawalProgressResEvent({required this.data});
}
