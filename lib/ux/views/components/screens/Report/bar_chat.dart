import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../res/app_colors.dart';
class DailySale {
  final DateTime date;
  final double amount;
  final int count;

  DailySale({
    required this.date,
    required this.amount,
    required this.count,
  });
}

class BarChart extends StatelessWidget {
  final List<DailySale> data;

  const BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxAmount = data.map((d) => d.amount).reduce(
            (a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((d) {
        final barHeight = (d.amount / maxAmount);
        final isToday = d.date.day == DateTime.now().day;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${ConstantUtil.currencySymbol} ${(d.amount / 1000).toStringAsFixed(1)}k',
                  style: TextStyle(
                    fontSize: 9,
                    color: isToday
                        ? AppColors.primaryColor
                        : Colors.grey,
                    fontWeight: isToday
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 3),
          RepaintBoundary(
            child:AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  height: 120 * barHeight,
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withValues(alpha: 0.35),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4)),
                  ),
                )),
                const SizedBox(height: 4),
                Text(
                  _dayLabel(d.date),
                  style: TextStyle(
                    fontSize: 10,
                    color: isToday
                        ? AppColors.primaryColor
                        : Colors.grey,
                    fontWeight: isToday
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _dayLabel(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[d.weekday - 1];
  }
}