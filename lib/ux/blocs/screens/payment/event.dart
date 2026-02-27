
import '../../../models/shared/progress/info.dart';
import '../../../models/terminal_sign_on_response.dart';

sealed class PaymentEvent {}
final class  PaymentGoBackEvent extends PaymentEvent {}
final class  PaymentExitEvent extends PaymentEvent {}
final class  PaymentPromptReferenceEvent extends PaymentEvent {}
final class  PaymentPromptCurrencyEvent extends PaymentEvent {}

final class  PaymentSetCurrencyEvent extends PaymentEvent {
  final Currency? data;

  PaymentSetCurrencyEvent({required this.data,});
}



final class  PaymentSetAmountEvent extends PaymentEvent {

  final double amount;

  PaymentSetAmountEvent({required this.amount,});

}
// final class  PaymentSetPaymentTypeEvent extends PaymentEvent {
//
//   final SalePaymentType type;
//
//   PaymentSetPaymentTypeEvent({required this.type});
//
// }

final class PaymentProgressResEvent extends PaymentEvent {
  final ProgressInfo? data;


  PaymentProgressResEvent({
    required this.data,
  });
}

