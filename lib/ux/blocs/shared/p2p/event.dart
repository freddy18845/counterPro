import "package:eswaini_destop_app/ux/models/screens/payment/payment_option.dart";

abstract class P2PEvent {
  const P2PEvent();
}

// Navigate back event
class P2PGoBackEvent extends P2PEvent {
  const P2PGoBackEvent();
}

// Exit P2P flow event
class P2PExitEvent extends P2PEvent {
  const P2PExitEvent();
}

// Prompt currency selection event
class P2PSetSenderAccountEvent extends P2PEvent {
  final String senderAccountNum;
  const P2PSetSenderAccountEvent({required this.senderAccountNum});
}

// Set payment type event
class P2PSetRecipientAccountEvent extends P2PEvent {
  final String recipientAccountNum;

  const P2PSetRecipientAccountEvent({required this.recipientAccountNum});
}

// Process P2P transaction event
