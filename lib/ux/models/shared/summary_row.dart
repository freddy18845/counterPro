import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../platform/utils/constant.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isBold ? Colors.black87 : Colors.grey,
            fontWeight:
            isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "${ConstantUtil.currencySymbol} ${value}" ,
          style: TextStyle(
            fontSize: 13,
            fontWeight:
            isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor ??
                (isBold ? Colors.black87 : Colors.black87),
          ),
        ),
      ],
    );
  }
}