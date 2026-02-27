part of "bloc.dart";

sealed class PaymentState {}
final class  PaymentEnterAmountState extends PaymentState {}
final class  PaymentPaymentOptionState extends PaymentState {

  final bool forcePinOnCardFlow;

  PaymentPaymentOptionState({this.forcePinOnCardFlow = false,});

}
final class  PaymentSubmitTransactionState extends PaymentState {

  final bool isLoading;
  final String error;


  PaymentSubmitTransactionState({
    this.isLoading = true,
    this.error = "",
  });

}
// final class  PaymentReceiptState extends PaymentState {
//
//   final TransactionData transaction;
//
//   PaymentReceiptState({required this.transaction,});
//
// }
