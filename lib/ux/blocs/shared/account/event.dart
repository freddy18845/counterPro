import "package:eswaini_destop_app/ux/models/screens/payment/payment_option.dart";

abstract class AccountEvent {
  const AccountEvent();
}

// Navigate back event
class AccountGoBackEvent extends AccountEvent {
  const AccountGoBackEvent();
}

// Exit Account flow event
class AccountExitEvent extends AccountEvent {
  const AccountExitEvent();
}

// Prompt currency selection event
class AccountSetSenderAccountEvent extends AccountEvent {
  final String senderAccountNum;
  const AccountSetSenderAccountEvent({required this.senderAccountNum});
}

// Set payment type event
class AccountSetRecipientAccountEvent extends AccountEvent {
  final String recipientAccountNum;

  const AccountSetRecipientAccountEvent({required this.recipientAccountNum});
}

// Process Account transaction event
