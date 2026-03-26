import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../res/app_colors.dart';

class DateFilterBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSet;

  const DateFilterBtn({
    required this.label,
    required this.onTap,
    required this.isSet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSet
              ? AppColors.primaryColor.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSet
                ? AppColors.primaryColor.withOpacity(0.5)
                : Colors.grey.withOpacity(0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: isSet ? AppColors.primaryColor : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSet ? AppColors.primaryColor : Colors.grey,
                fontWeight: isSet ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}