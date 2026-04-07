// ── Price row helper ──────────────────────────────────────────
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  final double labelSize;
  final double valueSize;

  const PriceRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
    this.labelSize = 14,
    this.valueSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: labelSize,
                fontWeight: bold
                    ? FontWeight.bold
                    : FontWeight.normal)),
        Text(value,
            style: TextStyle(
              fontSize: valueSize,
              fontWeight:
              bold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            )),
      ],
    );
  }
}