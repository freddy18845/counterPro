import "package:eswaini_destop_app/ux/models/screens/payment/payment_option.dart";


abstract class WalletEvent {
  const WalletEvent();
}

// Navigate back event
class WalletGoBackEvent extends WalletEvent {
  const WalletGoBackEvent();
}

// Exit wallet flow event
class WalletExitEvent extends WalletEvent {
  const WalletExitEvent();
}

// Prompt currency selection event
class WalletNetworkPromptEvent extends WalletEvent {
  const WalletNetworkPromptEvent();
}

// Set payment type event
class WalletSetNetWorkTypeEvent extends WalletEvent {
  final PaymentOption paymentType;

  const WalletSetNetWorkTypeEvent({required this.paymentType});
}

// Process wallet transaction event

