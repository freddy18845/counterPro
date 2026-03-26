import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color color;
  final CustomPainter icon;

  const CustomActionButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CustomPaint(painter: icon),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Excel icon ────────────────────────────────────────────────
class ExcelIconPainter extends CustomPainter {
  const ExcelIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(3),
    );
    canvas.drawRRect(
      rRect,
      Paint()..color = const Color(0xFF1D6F42),
    );

    // Outline (stroke)
    canvas.drawRRect(
    rRect,
    Paint()
    ..color =  Colors.white // outline color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.8,
    );
    final tp = TextPainter(
      text: const TextSpan(
        text: 'X',
        style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas,
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Word icon ─────────────────────────────────────────────────
class WordIconPainter extends CustomPainter {
  const WordIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(3),
    );

// Fill
    canvas.drawRRect(
      rRect,
      Paint()..color = const Color(0xFF2B579A),
    );

// Outline (stroke)
    canvas.drawRRect(
      rRect,
      Paint()
        ..color =  Colors.white // outline color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    final tp = TextPainter(
      text: const TextSpan(
        text: 'W',
        style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas,
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}