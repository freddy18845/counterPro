part of 'bloc.dart';

abstract class WalletState {
  const WalletState();
}

// Initial state
class WalletInitialState extends WalletState {
  const WalletInitialState();
}

// Loading state
class WalletLoadingState extends WalletState {
  const WalletLoadingState();
}

// Balance loaded state
class WalletBalanceLoadedState extends WalletState {
  final double balance;
  final Currency currency;

  const WalletBalanceLoadedState({
    required this.balance,
    required this.currency,
  });
}

// Currency selected state
class WalletCurrencySelectedState extends WalletState {
  final Currency currency;

  const WalletCurrencySelectedState({required this.currency});
}

// Amount entered state
class WalletAmountEnteredState extends WalletState {
  final double amount;

  const WalletAmountEnteredState({required this.amount});
}

// Payment method selected state
class WalletPaymentMethodSelectedState extends WalletState {
  final PaymentOption paymentType;

  const WalletPaymentMethodSelectedState({required this.paymentType});
}

// Processing state
class WalletProcessingState extends WalletState {
  const WalletProcessingState();
}

// Transaction success state
class WalletTransactionSuccessState extends WalletState {
  final String message;

  const WalletTransactionSuccessState({required this.message});
}

// Transaction failed state
class WalletTransactionFailedState extends WalletState {
  final String message;

  const WalletTransactionFailedState({required this.message});
}

// Error state
class WalletErrorState extends WalletState {
  final String message;

  const WalletErrorState({required this.message});
}