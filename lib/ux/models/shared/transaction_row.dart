// ── Display model ─────────────────────────────────────────────
import 'package:eswaini_destop_app/ux/models/shared/pos_transaction.dart';

class TxnRow {
  final String reference;
  final String userName;
  final double amount;
  final PaymentMethod method;
  final PosTransactionStatus status;
  final DateTime date;
  final int saleOrderId;
  final String orderNumber;

  TxnRow( {
    required this.saleOrderId,
    required this.orderNumber,
    required this.reference,
    required this.userName,
    required this.amount,
    required this.method,
    required this.status,
    required this.date,
  });
}