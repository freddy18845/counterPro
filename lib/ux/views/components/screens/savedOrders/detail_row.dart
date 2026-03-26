import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../res/app_colors.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const DetailRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color:
                  isBold ? Colors.black87 : Colors.grey)),
          Text(value,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isBold
                      ? AppColors.primaryColor
                      : Colors.black87)),
        ],
      ),
    );
  }
}