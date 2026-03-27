import 'package:eswaini_destop_app/platform/utils/isar_manager.dart';
import 'package:eswaini_destop_app/ux/models/shared/company.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_user.dart';
import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:eswaini_destop_app/ux/utils/shared/onlineChecker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class SetupChecker {
  static Future<bool> isSetupDone(BuildContext context) async {
    final isar = IsarService.db; // ← .db not ()

    final company = await isar.companys.where().findFirst();
    final adminUser = await isar.posUsers
        .where()
        .filter()
        .roleEqualTo(UserRole.admin)
        .findFirst();
    return company != null && adminUser != null;
  }

  // Checks subscription status and shows warning toast when ≤ 7 days remain
  /// Returns `true` if subscription is still considered active/usable
  static Future<bool> checkAndHandleSubscriptionStatus(
    BuildContext context,
  ) async {
    final isar = IsarService.db;

    final company = await isar.companys.where().findFirst();
    if (company == null) {
      // No company record → treat as no subscription restriction
      return true;
    }

    // No end date means no expiration (lifetime / trial / etc.)
    if (company.subscriptionEndDate == null) {
      return true;
    }

    final endDate = company.subscriptionEndDate!;
    final now = DateTime.now();

    if (now.isAfter(endDate)) {
      // Already expired
      AppUtil.toastMessage(
        message: "Your subscription has expired!",
        context: context,
        backgroundColor: Colors.red,
      );

      return false;
    }

    // Calculate remaining time
    final difference = endDate.difference(now);
    final daysLeft = difference.inDays;

    if (daysLeft <= 7 && daysLeft >= 0) {
      // Show warning when 7 days or less remain
      String message;
      if (daysLeft == 0) {
        message = "Your subscription expires today!";
      } else if (daysLeft == 1) {
        message = "Your subscription expires tomorrow!";
      } else {
        message = "Your subscription expires in $daysLeft days";
      }
      AppUtil.toastMessage(
        message: message,
        context: context,
        backgroundColor: daysLeft <= 3 ? Colors.red : Colors.orange,
      );
    }

    // Still active (either before end date or no end date)
    return true;
  }

  static Future<bool> checkAndHandleSubscriptionStatusFromWeb(
    DateTime endDate,
    BuildContext context,
  ) async {
    final now = DateTime.now();

    if (now.isAfter(endDate)) {
      //Already expired
      AppUtil.toastMessage(
        message: "Your subscription has expired!",
        context: context,
        backgroundColor: Colors.red,
      );

      return false;
    }

    // Calculate remaining time
    final difference = endDate.difference(now);
    final daysLeft = difference.inDays;

    if (daysLeft <= 7 && daysLeft >= 0) {
      // Show warning when 7 days or less remain
      String message;
      if (daysLeft == 0) {
        message = "Your subscription expires today!";
      } else if (daysLeft == 1) {
        message = "Your subscription expires tomorrow!";
      } else {
        message = "Your subscription expires in $daysLeft days";
      }
      AppUtil.toastMessage(
        message: message,
        context: context,
        backgroundColor: daysLeft <= 3 ? Colors.red : Colors.orange,
      );
    }

    // Still active (either before end date or no end date)
    return true;
  }
}
