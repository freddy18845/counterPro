import 'dart:async';

import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:eswaini_destop_app/ux/views/fragements/configSetting/sync_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eswaini_destop_app/platform/utils/isar_manager.dart';
import 'package:eswaini_destop_app/ux/models/shared/category.dart';
import 'package:eswaini_destop_app/ux/models/shared/company.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_transaction.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_user.dart';
import 'package:eswaini_destop_app/ux/models/shared/product.dart';
import 'package:eswaini_destop_app/ux/models/shared/sale_order.dart';
import 'package:eswaini_destop_app/ux/utils/sessionManager.dart';
import '../../../res/app_colors.dart';
import '../../../utils/api_service.dart';
import '../../../utils/shared/api_config.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final _api = ApiService();
  final _isar = IsarService.db;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  DateTime? _lastSyncTime;
  DateTime? get lastSyncTime => _lastSyncTime;

  // ── Sync progress stream ──────────────────────────────────
  // listen to this in the UI to show live progress
  final StreamController<String> _progressController =
      StreamController<String>.broadcast();
  Stream<String> get progressStream => _progressController.stream;

  void _log(String message) {
    debugPrint('🔄 Sync: $message');
    _progressController.add(message);
  }

  // ─────────────────────────────────────────────────────────
  // ── FIRST TIME SETUP (fresh install) ─────────────────────
  // Pull EVERYTHING from server when user first logs in
  // ─────────────────────────────────────────────────────────
  Future<SyncResult> firstTimeSetup(BuildContext context) async {
    _log('Starting first time setup...');

    var result = SyncResult(pushed: 0, pulled: 0, failed: 0, errors: []);

    _isSyncing = true;

    try {
      // pull in strict order — company first so
      // session is populated before anything else loads
      _log('Pulling company data...');
      result = result + await _pullCompany(context);

      _log('Pulling users...');
      result = result + await _pullUsers();

      _log('Pulling categories...');
      result = result + await _pullCategories();

      _log('Pulling products...');
      result = result + await _pullProducts();

      _log('Pulling saved orders...');
      result = result + await _pullOrders();

      _log('Pulling transactions...');
      result = result + await _pullTransactions();

      _lastSyncTime = DateTime.now();
      await _saveLastSyncTime();
      await _markSetupDone();

      _log('First time setup complete!');
    } catch (e) {
      result = SyncResult(
        pushed: result.pushed,
        pulled: result.pulled,
        failed: result.failed + 1,
        errors: [...result.errors, 'Setup failed: $e'],
      );
    } finally {
      _isSyncing = false;
    }

    return result;
  }

  // ── Check if first time setup has been done ───────────────
  Future<bool> isFirstTimeSetup() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('sync_setup_done') ?? false);
  }

  Future<void> _markSetupDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sync_setup_done', true);
  }

  // reset setup flag — use when user logs out
  // so next login triggers fresh pull again
  Future<void> resetSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sync_setup_done');
    await prefs.remove('last_sync_time');
    _lastSyncTime = null;
  }

  // ─────────────────────────────────────────────────────────
  // ── FULL SYNC ENTRY POINT ─────────────────────────────────
  // ─────────────────────────────────────────────────────────
  Future<SyncResult> syncAll({
    bool pushLocal = true,
    bool pullRemote = true,
    required BuildContext context,
  }) async {
    if (_isSyncing) {
      return SyncResult(
        pushed: 0,
        pulled: 0,
        failed: 0,
        errors: ['Sync already in progress'],
      );
    }

    final syncEnabled = await ApiConfig.isSyncEnabled();
    if (!syncEnabled) {
      return SyncResult(
        pushed: 0,
        pulled: 0,
        failed: 0,
        errors: ['Sync is disabled'],
      );
    }

    _isSyncing = true;
    int pushed = 0;
    int pulled = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      AppUtil.toastMessage(
        message: AppStrings.syncingToServer,
        context: context,
        backgroundColor: Colors.white12
      );
      if (pushLocal) {
        // push in dependency order:
        // company → users → categories → products → orders → transactions
        final results = await Future.wait([
          _pushCompany(),
          _pushUsers(),
          _pushCategories(),
          _pushProducts(),
          _pushOrders(),
          _pushTransactions(),
        ]);

        for (final r in results) {
          pushed += r.pushed;
          failed += r.failed;
          errors.addAll(r.errors);
        }
      }

      if (pullRemote) {
        final pullResult = await _pullAll(context);
        pulled += pullResult.pulled;
        failed += pullResult.failed;
        errors.addAll(pullResult.errors);
      }

      _lastSyncTime = DateTime.now();
      await _saveLastSyncTime();
    } catch (e) {
      errors.add('Sync failed: $e');
    } finally {
      _isSyncing = false;
    }

    return SyncResult(
      pushed: pushed,
      pulled: pulled,
      failed: failed,
      errors: errors,
    );
  }

  // ─────────────────────────────────────────────────────────
  // ── PUSH METHODS ─────────────────────────────────────────
  // ─────────────────────────────────────────────────────────

  // ── Push company ──────────────────────────────────────────
  Future<SyncResult> _pushCompany() async {
    int pushed = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final company = await _isar.companys.where().findFirst();
      if (company == null)
        return SyncResult(pushed: 0, pulled: 0, failed: 0, errors: []);

      final response = await _api.post('/sync/company', {
        'name': company.name,
        'companyId': company.companyId,
        'slogan': company.slogan,
        'email': company.email,
        'address': company.address,
        'contactOne': company.contactOne,
        'contactTwo': company.contactTwo,
        'logoPath': company.logoPath,
        'subscriptionStartDate': company.subscriptionStartDate,
        'subscriptionEndDate': company.subscriptionEndDate,
        'updatedAt': company.updatedAt.toIso8601String(),
      });

      if (response.success) {
        pushed++;
      } else {
        failed++;
        errors.add('Company: ${response.error}');
      }
    } catch (e) {
      errors.add('Push company error: $e');
    }

    return SyncResult(
      pushed: pushed,
      pulled: 0,
      failed: failed,
      errors: errors,
    );
  }

  // ── Push users ────────────────────────────────────────────
  Future<SyncResult> _pushUsers() async {
    int pushed = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final users = await _isar.posUsers.where().findAll();

      for (final user in users) {
        final response = await _api.post('/sync/users', {
          'name': user.name,
          'email': user.email,
          // ← never push password hash to server
          // server manages its own auth
          'role': user.role.name,
          'isActive': user.isActive,
          'updatedAt': user.updatedAt.toIso8601String(),
        });

        if (response.success) {
          pushed++;
        } else {
          failed++;
          errors.add('User ${user.email}: ${response.error}');
        }
      }
    } catch (e) {
      errors.add('Push users error: $e');
    }

    return SyncResult(
      pushed: pushed,
      pulled: 0,
      failed: failed,
      errors: errors,
    );
  }

  // ── Push categories ───────────────────────────────────────
  Future<SyncResult> _pushCategories() async {
    int pushed = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final categories = await _isar.categorys.where().findAll();

      for (final cat in categories) {
        final response = await _api.post('/sync/categories', {
          'localId': cat.id,
          'name': cat.name,
          'description': cat.description,
          'isActive': cat.isActive,
          'updatedAt': cat.updatedAt.toIso8601String(),
        });

        if (response.success) {
          pushed++;
        } else {
          failed++;
          errors.add('Category ${cat.name}: ${response.error}');
        }
      }
    } catch (e) {
      errors.add('Push categories error: $e');
    }

    return SyncResult(
      pushed: pushed,
      pulled: 0,
      failed: failed,
      errors: errors,
    );
  }

  // ── Push products ─────────────────────────────────────────
  Future<SyncResult> _pushProducts() async {
    int pushed = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final products = await _isar.products.where().findAll();

      for (final p in products) {
        final response = await _api.post('/sync/products', {
          'localId': p.id,
          'name': p.name,
          // ← sku is the unique key — server uses this
          // to decide update vs insert
          'sku': p.sku,
          'barcodeId': p.barcodeId,
          'categoryName': p.categoryName,
          'costPrice': p.costPrice,
          'sellingPrice': p.sellingPrice,
          'stockQuantity': p.stockQuantity,
          'lowStockThreshold': p.lowStockThreshold,
          'isActive': p.isActive,
          'imageUrl': p.imageUrl ?? '',
          'createdAt': p.createdAt,
          'categoryId': p.categoryId,
          'updatedAt': p.updatedAt.toIso8601String(),
        });

        if (response.success) {
          pushed++;
        } else {
          failed++;
          errors.add('Product ${p.sku}: ${response.error}');
        }
      }
    } catch (e) {
      errors.add('Push products error: $e');
    }

    return SyncResult(
      pushed: pushed,
      pulled: 0,
      failed: failed,
      errors: errors,
    );
  }

  // ── Push orders ───────────────────────────────────────────
  Future<SyncResult> _pushOrders() async {
    int pushed = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final orders = await _isar.saleOrders.where().findAll();

      for (final order in orders) {
        final response = await _api.post('/sync/orders', {
          // ← orderNumber is the unique key
          // server uses this to deduplicate
          'id': order.id,
          'orderNumber': order.orderNumber,
          'status': order.status.name,
          'subtotal': order.subtotal,
          'discountAmount': order.discountAmount,
          'taxAmount': order.taxAmount,
          'totalAmount': order.totalAmount,
          'customerName': order.customerName,
          'note': order.note,
          'createdByUserId': order.createdByUserId,
          'createdAt': order.createdAt.toIso8601String(),
          'completedAt': order.completedAt?.toIso8601String(),
          'items': order.items
              .map(
                (i) => {
                  'productSku': i.productSku,
                  'productName': i.productName,
                  'unitPrice': i.unitPrice,
                  'costPrice': i.costPrice,
                  'quantity': i.quantity,
                  'discount': i.discount,
                  'totalPrice': i.totalPrice,
                },
              )
              .toList(),
        });

        if (response.success) {
          pushed++;
        } else {
          failed++;
          errors.add('Order ${order.orderNumber}: ${response.error}');
        }
      }
    } catch (e) {
      errors.add('Push orders error: $e');
    }

    return SyncResult(
      pushed: pushed,
      pulled: 0,
      failed: failed,
      errors: errors,
    );
  }

  // ── Push transactions ─────────────────────────────────────
  Future<SyncResult> _pushTransactions() async {
    int pushed = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final txns = await _isar.posTransactions.where().findAll();

      for (final txn in txns) {
        final response = await _api.post('/sync/transactions', {
          // ← transactionNumber is the unique key
          'transactionNumber': txn.transactionNumber,
          'orderNumber': txn.orderNumber,
          'paymentMethod': txn.paymentMethod.name,
          'status': txn.status.name,
          'amountPaid': txn.amountPaid,
          'changeGiven': txn.changeGiven,
          'totalAmount': txn.totalAmount,
          'refundReason': txn.refundReason,
          'processedByUserId': txn.processedByUserId,
          'timestamp': txn.timestamp.toIso8601String(),
        });

        if (response.success) {
          pushed++;
        } else {
          failed++;
          errors.add('Txn ${txn.transactionNumber}: ${response.error}');
        }
      }
    } catch (e) {
      errors.add('Push transactions error: $e');
    }

    return SyncResult(
      pushed: pushed,
      pulled: 0,
      failed: failed,
      errors: errors,
    );
  }

  // ─────────────────────────────────────────────────────────
  // ── PULL ALL FROM SERVER ──────────────────────────────────
  // ─────────────────────────────────────────────────────────
  Future<SyncResult> _pullAll(BuildContext context) async {
    var result = SyncResult(pushed: 0, pulled: 0, failed: 0, errors: []);

    final company = await _pullCompany(context);
    result = _merge(result, company);

    final users = await _pullUsers();
    result = _merge(result, users);

    final categories = await _pullCategories();
    result = _merge(result, categories);

    final products = await _pullProducts();
    result = _merge(result, products);

    final orders = await _pullOrders();
    result = _merge(result, orders);

    final transactions = await _pullTransactions();
    result = _merge(result, transactions);

    return result;
  }

  // add this helper
  SyncResult _merge(SyncResult a, SyncResult b) => SyncResult(
    pushed: a.pushed + b.pushed,
    pulled: a.pulled + b.pulled,
    failed: a.failed + b.failed,
    errors: [...a.errors, ...b.errors],
  );

  // ── Pull company ──────────────────────────────────────────
  Future<SyncResult> _pullCompany(BuildContext context) async {
    int pulled = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final response = await _api.get('/sync/company');
      if (!response.success) {
        return SyncResult(
          pushed: 0,
          pulled: 0,
          failed: 1,
          errors: ['Pull company: ${response.error}'],
        );
      }

      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data == null)
        return SyncResult(pushed: 0, pulled: 0, failed: 0, errors: []);

      await _isar.writeTxn(() async {
        // only one company record ever
        final existing = await _isar.companys.where().findFirst();
        final company = existing ?? Company();

        company
          ..companyId = data['companyId'] ?? company.companyId
          ..name = data['name'] ?? company.name
          ..subscriptionEndDate =
              data['subscriptionEndDate'] ?? company.subscriptionEndDate
          ..subscriptionStartDate =
              data['subscriptionStartDate'] ?? company.subscriptionStartDate
          ..slogan = data['slogan'] as String?
          ..email = data['email'] ?? company.email
          ..address = data['address'] ?? company.address
          ..contactOne = data['contactOne'] ?? company.contactOne
          ..contactTwo = data['contactTwo'] ?? company.contactTwo
          ..updatedAt = DateTime.now();

        if (existing == null) {
          company.createdAt = DateTime.now();
        }

        await _isar.companys.put(company);
      });

      // refresh session with new company data
      await SessionManager().refreshCompany(context);
      pulled++;
    } catch (e) {
      failed++;
      errors.add('Pull company error: $e');
    }

    return SyncResult(
      pushed: 0,
      pulled: pulled,
      failed: failed,
      errors: errors,
    );
  }

  // ── Pull users ────────────────────────────────────────────
  Future<SyncResult> _pullUsers() async {
    int pulled = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final response = await _api.get('/sync/users');
      if (!response.success) {
        return SyncResult(
          pushed: 0,
          pulled: 0,
          failed: 1,
          errors: ['Pull users: ${response.error}'],
        );
      }

      final items = response.data!['data'] as List? ?? [];

      await _isar.writeTxn(() async {
        for (final item in items) {
          final map = item as Map<String, dynamic>;
          final email = map['email'] as String? ?? '';

          if (email.isEmpty) continue;

          // ← deduplicate by email
          final existing = await _isar.posUsers
              .where()
              .filter()
              .emailEqualTo(email)
              .findFirst();

          final user = existing ?? PosUser();
          user
            ..name = map['name'] ?? user.name
            ..email = email
            ..role = _parseRole(map['role'])
            ..isActive = map['isActive'] as bool? ?? true
            ..updatedAt = DateTime.now();

          // ← never overwrite local password from server
          // server does not send passwordHash
          if (existing == null) {
            user
              ..passwordHash = 'changeme'
              ..createdAt = DateTime.now();
          }

          await _isar.posUsers.put(user);
          pulled++;
        }
      });
    } catch (e) {
      failed++;
      errors.add('Pull users error: $e');
    }

    return SyncResult(
      pushed: 0,
      pulled: pulled,
      failed: failed,
      errors: errors,
    );
  }

  // ── Pull categories ───────────────────────────────────────
  Future<SyncResult> _pullCategories() async {
    int pulled = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final response = await _api.get('/sync/categories');
      if (!response.success) {
        return SyncResult(
          pushed: 0,
          pulled: 0,
          failed: 1,
          errors: ['Pull categories: ${response.error}'],
        );
      }

      final items = response.data!['data'] as List? ?? [];

      await _isar.writeTxn(() async {
        for (final item in items) {
          final map = item as Map<String, dynamic>;
          final name = map['name'] as String? ?? '';

          if (name.isEmpty) continue;

          // ← deduplicate by name
          final existing = await _isar.categorys
              .where()
              .filter()
              .nameEqualTo(name)
              .findFirst();

          final cat = existing ?? Category();
          cat
            ..name = name
            ..description = map['description'] as String?
            ..isActive = map['isActive'] as bool? ?? true
            ..updatedAt = DateTime.now();

          if (existing == null) {
            cat.createdAt = DateTime.now();
          }

          await _isar.categorys.put(cat);
          pulled++;
        }
      });
    } catch (e) {
      failed++;
      errors.add('Pull categories error: $e');
    }

    return SyncResult(
      pushed: 0,
      pulled: pulled,
      failed: failed,
      errors: errors,
    );
  }

  // ── Pull products ─────────────────────────────────────────
  Future<SyncResult> _pullProducts() async {
    int pulled = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final response = await _api.get('/sync/products');
      if (!response.success) {
        return SyncResult(
          pushed: 0,
          pulled: 0,
          failed: 1,
          errors: ['Pull products: ${response.error}'],
        );
      }

      final items = response.data!['data'] as List? ?? [];

      await _isar.writeTxn(() async {
        for (final item in items) {
          final map = item as Map<String, dynamic>;
          final sku = map['sku'] as String? ?? '';

          if (sku.isEmpty) continue;

          // ← deduplicate by SKU — this is the unique key
          final existing = await _isar.products
              .where()
              .filter()
              .skuEqualTo(sku)
              .findFirst();

          final product = existing ?? Product();
          product
            ..name = map['name'] ?? ''
            ..categoryId = map['categoryId'] as int? ?? product.categoryId
            ..categoryName = map['categoryName'] ?? ''
            ..sku = sku
            ..imageUrl = map["imageUrl"] ?? ''
            ..costPrice = (map['costPrice'] as num?)?.toDouble() ?? 0
            ..sellingPrice = (map['sellingPrice'] as num?)?.toDouble() ?? 0
            ..stockQuantity = map['stockQuantity'] as int? ?? 0
            ..lowStockThreshold = map['lowStockThreshold'] as int? ?? 5
            ..isActive = map['isActive'] as bool? ?? true
            ..updatedAt = DateTime.now();

          if (existing == null) {
            product.createdAt = DateTime.now();
          }

          await _isar.products.put(product);
          pulled++;
        }
      });
    } catch (e) {
      failed++;
      errors.add('Pull products error: $e');
    }

    return SyncResult(
      pushed: 0,
      pulled: pulled,
      failed: failed,
      errors: errors,
    );
  }

  // ── Pull orders ───────────────────────────────────────────
  Future<SyncResult> _pullOrders() async {
    int pulled = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final response = await _api.get('/sync/orders');
      if (!response.success) {
        return SyncResult(
          pushed: 0,
          pulled: 0,
          failed: 1,
          errors: ['Pull orders: ${response.error}'],
        );
      }

      final items = response.data!['data'] as List? ?? [];

      await _isar.writeTxn(() async {
        for (final item in items) {
          final map = item as Map<String, dynamic>;
          final orderNumber = map['orderNumber'] as String? ?? '';
          final createdByUserId = map['createdByUserId'] as int? ?? 0;

          if (orderNumber.isEmpty) continue;

          // ← deduplicate by orderNumber
          final existing = await _isar.saleOrders
              .where()
              .filter()
              .orderNumberEqualTo(orderNumber)
              .and()
              .createdByUserIdEqualTo(createdByUserId)
              .findFirst();

          // ← never overwrite a local completed order
          // with a server version — local is source of truth
          if (existing != null &&
              existing.status == SaleOrderStatus.completed) {
            continue;
          }

          final order = existing ?? SaleOrder();
          order
            ..id = order.id
            ..orderNumber = orderNumber
            ..status = _parseOrderStatus(map['status'])
            ..subtotal = (map['subtotal'] as num?)?.toDouble() ?? 0
            ..discountAmount = (map['discountAmount'] as num?)?.toDouble() ?? 0
            ..taxAmount = (map['taxAmount'] as num?)?.toDouble() ?? 0
            ..totalAmount = (map['totalAmount'] as num?)?.toDouble() ?? 0
            ..customerName = map['customerName'] as String?
            ..note = map['note'] as String?
            ..createdByUserId = map['createdByUserId'] as int? ?? 0
            ..createdAt =
                DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now();

          if (map['completedAt'] != null) {
            order.completedAt = DateTime.tryParse(map['completedAt']);
          }

          // rebuild items
          final rawItems = map['items'] as List? ?? [];
          order.items = rawItems.map((i) {
            final iMap = i as Map<String, dynamic>;
            return SaleItem()
              ..barcodeId = iMap['barcodeId'] ?? ''
              ..productName = iMap['productName'] ?? ''
              ..productSku = iMap['productSku'] ?? ''
              ..unitPrice = (iMap['unitPrice'] as num?)?.toDouble() ?? 0
              ..costPrice = (iMap['costPrice'] as num?)?.toDouble() ?? 0
              ..quantity = iMap['quantity'] as int? ?? 1
              ..discount = (iMap['discount'] as num?)?.toDouble() ?? 0
              ..totalPrice = (iMap['totalPrice'] as num?)?.toDouble() ?? 0;
          }).toList();

          await _isar.saleOrders.put(order);
          pulled++;
        }
      });
    } catch (e) {
      failed++;
      errors.add('Pull orders error: $e');
    }

    return SyncResult(
      pushed: 0,
      pulled: pulled,
      failed: failed,
      errors: errors,
    );
  }

  // ── Pull transactions ─────────────────────────────────────
  Future<SyncResult> _pullTransactions() async {
    int pulled = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final response = await _api.get('/sync/transactions');
      if (!response.success) {
        return SyncResult(
          pushed: 0,
          pulled: 0,
          failed: 1,
          errors: ['Pull transactions: ${response.error}'],
        );
      }

      final items = response.data!['data'] as List? ?? [];

      await _isar.writeTxn(() async {
        for (final item in items) {
          final map = item as Map<String, dynamic>;
          final txnNumber = map['transactionNumber'] as String? ?? '';
          final processedByUserId = map['processedByUserId'] as int? ?? 0;

          if (txnNumber.isEmpty) continue;

          // ← deduplicate by transactionNumber
          // this is the most important check —
          // a completed transaction must never be duplicated
          final existing = await _isar.posTransactions
              .where()
              .filter()
              .transactionNumberEqualTo(txnNumber)
              .and()
              .processedByUserIdEqualTo(processedByUserId)
              .findFirst();

          // ← if it already exists locally skip it entirely
          // transactions are immutable once completed
          if (existing != null) continue;

          final txn = PosTransaction()
            ..transactionNumber = txnNumber
            ..id = map['id']
            ..orderNumber = map['orderNumber'] as String? ?? ''
            ..paymentMethod = _parsePaymentMethod(map['paymentMethod'])
            ..status = _parseTxnStatus(map['status'])
            ..amountPaid = (map['amountPaid'] as num?)?.toDouble() ?? 0
            ..changeGiven = (map['changeGiven'] as num?)?.toDouble() ?? 0
            ..totalAmount = (map['totalAmount'] as num?)?.toDouble() ?? 0
            ..processedByUserId = map['processedByUserId'] as int? ?? 0
            ..saleOrderId =
                map['saleOrderId'] as int? ??
                0 // ← add this
            ..orderNumber = map['orderNumber'] as String? ?? ''
            ..timestamp =
                DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now();

          await _isar.posTransactions.put(txn);
          pulled++;
        }
      });
    } catch (e) {
      failed++;
      errors.add('Pull transactions error: $e');
    }

    return SyncResult(
      pushed: 0,
      pulled: pulled,
      failed: failed,
      errors: errors,
    );
  }

  // ─────────────────────────────────────────────────────────
  // ── PARSERS ───────────────────────────────────────────────
  // ─────────────────────────────────────────────────────────
  UserRole _parseRole(dynamic val) {
    switch (val?.toString()) {
      case 'admin':
        return UserRole.admin;
      case 'manager':
        return UserRole.manager;
      default:
        return UserRole.cashier;
    }
  }

  SaleOrderStatus _parseOrderStatus(dynamic val) {
    switch (val?.toString()) {
      case 'completed':
        return SaleOrderStatus.completed;
      case 'cancelled':
        return SaleOrderStatus.cancelled;
      default:
        return SaleOrderStatus.saved;
    }
  }

  PosTransactionStatus _parseTxnStatus(dynamic val) {
    switch (val?.toString()) {
      case 'refunded':
        return PosTransactionStatus.refunded;
      case 'voided':
        return PosTransactionStatus.voided;
      default:
        return PosTransactionStatus.completed;
    }
  }

  PaymentMethod _parsePaymentMethod(dynamic val) {
    switch (val?.toString()) {
      case 'card':
        return PaymentMethod.card;
      case 'mobileMoney':
        return PaymentMethod.mobileMoney;
      case 'split':
        return PaymentMethod.split;
      default:
        return PaymentMethod.cash;
    }
  }

  // ── Last sync time ────────────────────────────────────────
  Future<void> _saveLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_sync_time', _lastSyncTime!.toIso8601String());
  }

  Future<void> loadLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString('last_sync_time');
    if (str != null) {
      _lastSyncTime = DateTime.tryParse(str);
    }
  }
}
