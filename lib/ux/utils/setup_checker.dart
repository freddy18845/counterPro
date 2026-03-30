// lib/platform/utils/setup_checker.dart
// add this method
import 'package:eswaini_destop_app/ux/models/shared/company.dart';
import 'package:isar/isar.dart';

import '../../platform/utils/isar_manager.dart';
import '../models/shared/pos_user.dart';

class SetupChecker {
  static Future<bool> isSetupDone() async {
    final isar = IsarService.db;
    final company = await isar.companys.where().findFirst();
    final adminUser = await isar.posUsers
        .where()
        .filter()
        .roleEqualTo(UserRole.admin)
        .findFirst();
    return company != null && adminUser != null;
  }

  // ← new — check if user needs to change password
  static Future<bool> userNeedsPasswordChange(
      String email) async {
    final isar = IsarService.db;
    final user = await isar.posUsers
        .where()
        .filter()
        .emailEqualTo(email)
        .findFirst();
    return user?.passwordHash == 'changeme123';
  }
}