import 'package:eswaini_destop_app/ux/res/app_theme.dart';
import 'package:eswaini_destop_app/ux/utils/sessionManager.dart';
import 'package:eswaini_destop_app/ux/views/components/dialogs/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/shared/pos_transaction.dart';
import '../../../../res/app_colors.dart';
import '../../../../utils/shared/app.dart';
import '../configSetting/small_btn.dart';

class TxnTableRow extends StatelessWidget {
  final List<String> cells;
  final bool isHeader;
  final bool isAlternate;
  final PosTransactionStatus? status;
  final Function(PosTransactionStatus status)? onStatusChanged;
  const TxnTableRow({
    required this.cells,
    this.isHeader = false,
    this.isAlternate = false,
    this.status,
    this.onStatusChanged,
  });

  Color _statusColor(PosTransactionStatus s) {
    switch (s) {
      case PosTransactionStatus.completed:
        return Colors.green;
      case PosTransactionStatus.refunded:
        return Colors.orange;
      case PosTransactionStatus.voided:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            final isStatusCol = !isHeader && i == 4 && status != null;

            return Expanded(
              child: isStatusCol
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(status!).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _statusColor(status!).withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          cell,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _statusColor(status!),
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
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<PosTransactionStatus>(
                        isDense: true,
                        icon: SmallBtn(
                          icon: Icons.edit_outlined,
                          color: AppColors.primaryColor,
                          onTap: null,
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                        items: PosTransactionStatus.values
                            .where((s) => s != status)
                            .map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(
                              AppTheme.capitalizeFirst(s.name),
                              style: TextStyle(color: _statusColor(s)),
                            ),
                          );
                        }).toList(),
                          onChanged: (newStatus) async {
                            if (SessionManager().isCashier) {
                              AppUtil.toastMessage(
                                message: 'Sorry, You are not approved for this action.',
                                context: context,
                              );
                            } else {
                              if (newStatus != null) {
                                bool result = await AppUtil.displayDialog(
                                  dismissible: false,
                                  context: context,
                                  child: MessageDialog(
                                    title: 'Order Status Update',
                                    message:
                                    "Are you sure you want to   ${AppTheme.capitalizeFirst(newStatus.name)} this transaction?",
                                  ),
                                );

                                if (result) {
                                  onStatusChanged!(newStatus);
                                }
                              }
                              // 👈 YOU must handle this
                            }
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
