// ── Donut chart ───────────────────────────────────────────────
import 'package:eswaini_destop_app/ux/views/components/screens/Report/payment_breakdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final List<PaymentBreakdown> data;
  final double total;

  const DonutChart({required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DonutPainter(data: data, total: total),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${(total / 1000).toStringAsFixed(1)}k',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              'Total',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class DonutPainter extends CustomPainter {
  final List<PaymentBreakdown> data;
  final double total;

  DonutPainter({required this.data, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height
        ? size.width / 2 - 8
        : size.height / 2 - 8;
    const strokeWidth = 18.0;

    double startAngle = -1.5708;

    for (final item in data) {
      final sweepAngle = (item.amount / total) * 6.2832;
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle - 0.05,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}