import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:eswaini_destop_app/ux/models/shared/pos_user.dart';
import 'package:eswaini_destop_app/ux/models/shared/category.dart';
import 'package:eswaini_destop_app/ux/models/shared/product.dart';
import 'package:eswaini_destop_app/ux/models/shared/sale_order.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_transaction.dart';
import '../../ux/models/shared/company.dart';
import '../../ux/models/shared/inventory.dart';
import '../../ux/models/shared/notification_cooldown.dart';
import '../../ux/models/shared/notification_settings.dart';
import '../../ux/models/shared/remember_me_entity.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  factory IsarService() => _instance;
  IsarService._internal();

  Isar? isar;

  static Isar get db {
    assert(
    _instance.isar != null && _instance.isar!.isOpen,
    '❌ IsarService not initialized. Await IsarService().init() first.',
    );
    return _instance.isar!;
  }

  static Future<Isar> get asyncDb async {
    if (_instance.isar == null || !_instance.isar!.isOpen) {
      await _instance.init();
    }
    return _instance.isar!;
  }

  Future<void> init() async {
    if (isar != null && isar!.isOpen) return;

    final String isarPath = await _resolveIsarPath();
    print('📂 Isar path: $isarPath');

    isar = await Isar.open(
      [
        PosUserSchema,
        CategorySchema,
        ProductSchema,
        InventoryLogSchema,
        SaleOrderSchema,
        PosTransactionSchema,
        CompanySchema,
        RememberMeEntitySchema,
        NotificationSettingsSchema,
        NotificationCooldownSchema,
      ],
      directory: isarPath,
      name: 'eswaini_isar',
    );

    print('✅ Isar opened at $isarPath');
  }

  /// Tries multiple path strategies until one works
  static Future<String> _resolveIsarPath() async {
    final List<Future<Directory> Function()> strategies = [
      // ✅ Best for Windows: C:\Users\<user>\AppData\Roaming\<app>
          () => getApplicationSupportDirectory(),
      // Fallback 1: Documents
          () => getApplicationDocumentsDirectory(),
      // Fallback 2: Temp dir
          () => getTemporaryDirectory(),
    ];

    for (final strategy in strategies) {
      try {
        final base = await strategy();
        final target = Directory(p.join(base.path, 'eswaini_db'));

        // Force-create the directory
        if (!target.existsSync()) {
          target.createSync(recursive: true);
        }

        // Confirm it's writable
        final testFile = File(p.join(target.path, '.test'));
        testFile.writeAsStringSync('ok');
        testFile.deleteSync();

        return target.path; // ✅ This path works
      } catch (e) {
        print('⚠️ Path strategy failed: $e — trying next...');
        continue;
      }
    }

    throw Exception('❌ Could not find any writable path for Isar on this device.');
  }
}