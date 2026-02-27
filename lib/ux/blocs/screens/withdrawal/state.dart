part of "bloc.dart";

sealed class WithdrawalState {}
final class  WithdrawalEnterAmountState extends WithdrawalState {}
final class  WithdrawalPaymentMethodSelectedState extends WithdrawalState {}

final class  WithdrawalSelectedWalletState extends WithdrawalState {
  final WalletNetwork data;
  WithdrawalSelectedWalletState({
  required this.data
  });

}
final class  WithdrawalWithdrawalOptionState extends WithdrawalState {

  final bool forcePinOnCardFlow;

  WithdrawalWithdrawalOptionState({this.forcePinOnCardFlow = false,});

}
final class  WithdrawalSubmitTransactionState extends WithdrawalState {

  final bool isLoading;
  final String error;


  WithdrawalSubmitTransactionState({
    this.isLoading = true,
    this.error = "",
  });

}
final class  WithdrawalPaymentMethodAccountState extends WithdrawalState {}
final class  WithdrawalPaymentMethodP2PState extends WithdrawalState {}

