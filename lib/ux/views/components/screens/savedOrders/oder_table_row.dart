import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/shared/sale_order.dart';
import '../../../../res/app_colors.dart';
import 'action_btn.dart';

class OrderTableRow extends StatelessWidget {
  final List<String> cells;
  final bool isHeader;
  final bool isAlternate;
  final SaleOrder? order;
  final VoidCallback? onResume;
  final VoidCallback? onCancel;
  final VoidCallback? onView;

  const OrderTableRow({
    required this.cells,
    this.isHeader = false,
    this.isAlternate = false,
    this.order,
    this.onResume,
    this.onCancel,
    this.onView,
  });

  Color _statusColor(SaleOrderStatus s) {
    switch (s) {
      case SaleOrderStatus.saved:
        return Colors.orange;
      case SaleOrderStatus.completed:
        return Colors.green;
      case SaleOrderStatus.cancelled:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isHeader
            ? AppColors.primaryColor.withValues(alpha: 0.12)
            : isAlternate
            ? Colors.grey.withValues(alpha: 0.04)
            : Colors.transparent,
        border: Border(
            bottom:
            BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
      ),
      child: Row(
        children: [
          // ── data cells with fixed widths ──────────────────
          ...cells.asMap().entries.map((entry) {
            final i = entry.key;
            final cell = entry.value;
            final isStatusCol = !isHeader && i == 4 && order != null;

            return Expanded(

              flex: 1,
              child: isStatusCol
                  ? Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor(order!.status)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _statusColor(order!.status)
                          .withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    cell,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _statusColor(order!.status),
                    ),
                  ),
                ),
              )
                  : Text(
                cell,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isHeader
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isHeader
                      ? AppColors.primaryColor
                      : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }),

          // ── actions column — fixed width for both header and rows
          Expanded(
            flex: 1,
            child: isHeader
                ? Text(
              'Actions',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // view — always visible
                ActionBtn(
                  icon: Icons.visibility_outlined,
                  color: AppColors.primaryColor,
                  onTap: onView,
                ),
                const SizedBox(width: 6),

                // pay — fixed slot
                SizedBox(
                  width: 46,
                  child: onResume != null
                      ? ActionBtn(
                    icon: Icons.play_circle_outline,
                    color: Colors.green,
                    onTap: onResume,
                    label: 'Pay',
                  )
                      : const SizedBox(),
                ),
                const SizedBox(width: 6),

                // cancel — fixed slot
                SizedBox(
                  width: 26,
                  child: onCancel != null
                      ? ActionBtn(
                    icon: Icons.cancel_outlined,
                    color: Colors.red,
                    onTap: onCancel,
                  )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}