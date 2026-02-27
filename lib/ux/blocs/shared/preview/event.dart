part of "bloc.dart";

sealed class PreviewEvent {}
final class  PreviewPrintEvent extends PreviewEvent {}
final class  PreviewTransactionEvent extends PreviewEvent {

  final TransactionData transactionData;
  PreviewTransactionEvent({required this.transactionData});
}
