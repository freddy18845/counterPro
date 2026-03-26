import 'package:isar/isar.dart';

part 'pos_transaction.g.dart';

enum PaymentMethod { cash, card, mobileMoney, split }
enum PosTransactionStatus { completed, refunded, voided }

@collection
class PosTransaction {
  Id id = Isar.autoIncrement;

  late String transactionNumber;
  late int saleOrderId;
  late String orderNumber;

  @Enumerated(EnumType.name)
  late PaymentMethod paymentMethod;

  @Enumerated(EnumType.name)
  late PosTransactionStatus status;

  late double amountPaid;
  late double changeGiven;
  late double totalAmount;

  String? refundReason;
  late int processedByUserId;
  late DateTime timestamp;
}