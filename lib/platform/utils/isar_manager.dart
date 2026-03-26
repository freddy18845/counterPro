import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_user.dart';
import 'package:eswaini_destop_app/ux/models/shared/category.dart';
import 'package:eswaini_destop_app/ux/models/shared/product.dart';
import 'package:eswaini_destop_app/ux/models/shared/sale_order.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_transaction.dart';

import '../../ux/models/shared/company.dart';
import '../../ux/models/shared/inventory.dart';
import '../../ux/models/shared/notification_settings.dart';
import '../../ux/models/shared/remember_me_entity.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  factory IsarService() => _instance;
  IsarService._internal();

  late Isar isar;
  static Isar get db => _instance.isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
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
        NotificationSettingsSchema
      ],
      directory: dir.path,
    );
  }
}

// // save company
// await isar.writeTxn(() async {
// await isar.companys.put(Company()
// ..name = 'Acme POS'
// ..slogan = 'Fast and Reliable'   // optional, can be null
// ..email = 'info@acmepos.com'
// ..contactOne = '+268 7654 3210'
// ..contactTwo = '+268 7654 3211'
// ..createdAt = DateTime.now()
// ..updatedAt = DateTime.now());
// });


// get company
// final company = await isar.companys.where().findFirst();