
// ── User table row ────────────────────────────────────────────
import 'dart:ui';

import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/small_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/shared/pos_user.dart';
import '../../../../res/app_colors.dart';
import '../../../../utils/sessionManager.dart';

class UserRow extends StatelessWidget {
  final List<String> cells;
  final bool isHeader;
  final bool isAlternate;
  final PosUser? user;
  final VoidCallback? onEdit;
  final VoidCallback? onToggle;

  const UserRow({
    required this.cells,
    this.isHeader = false,
    this.isAlternate = false,
    this.user,
    this.onEdit,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isHeader
            ? AppColors.primaryColor.withOpacity(0.12)
            : isAlternate
            ? Colors.grey.withOpacity(0.04)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.15)),
        ),
      ),
      child: Row(
        children: [
          // ── data cells with fixed widths ──────────────────
          ...cells.asMap().entries.map((entry) {
            final i = entry.key;
            final cell = entry.value;
            final isStatus = !isHeader && i == 3 && user != null;
            final isRole = !isHeader && i == 2 && user != null;

            return Expanded(
              child: isStatus
                  ? Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: user!.isActive
                        ? Colors.green
                        .withValues(alpha: 0.1)
                        : Colors.red
                        .withValues(alpha: 0.1),
                    borderRadius:
                    BorderRadius.circular(20),
                    border: Border.all(
                      color: user!.isActive
                          ? Colors.green
                          .withValues(alpha: 0.4)
                          : Colors.red
                          .withValues(alpha: 0.4),
                    ),

                  ),
                child: Text(cell,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color:
                        user!.isActive
                            ? Colors.green

                            : Colors.red
                            )),
                ))
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
              ),
            );
          }),
          Align(
            alignment: Alignment.centerLeft,
            child: isHeader
                ? Text(
              'Actions',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            )
                : !isHeader && SessionManager().isAdmin?Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmallBtn(
                  icon: Icons.edit_outlined,
                  color: AppColors.primaryColor,
                  onTap: onEdit,
                ),
                const SizedBox(width: 6),
                if (onToggle != null)
                  SmallBtn(
                    icon: user?.isActive == true
                        ? Icons.block_outlined
                        : Icons.check_circle_outline,
                    color: user?.isActive == true
                        ? Colors.red
                        : Colors.green,
                    onTap: onToggle,
                  ),
              ],
            ):SizedBox(),
          ),
        ],
      ),
    );

  }
}