import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../res/app_colors.dart';

class DateBtn extends StatelessWidget {
  final String label;
  final bool isSet;
  final VoidCallback onTap;

  const DateBtn({
    required this.label,
    required this.isSet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSet
              ? AppColors.primaryColor.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSet
                ? AppColors.primaryColor.withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 14,
                color: isSet ? AppColors.primaryColor : Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSet ? AppColors.primaryColor : Colors.grey,
                fontWeight:
                isSet ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}