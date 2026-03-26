import 'dart:ui';

class PaymentBreakdown {
  final String method;
  final double amount;
  final int count;
  final Color color;

  PaymentBreakdown({
    required this.method,
    required this.amount,
    required this.count,
    required this.color,
  });
}