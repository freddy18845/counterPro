import 'dart:async';
import 'dart:io';
import 'package:eswaini_destop_app/ux/models/shared/product.dart';
import 'package:eswaini_destop_app/ux/models/shared/notification_settings.dart';
import 'package:eswaini_destop_app/ux/models/shared/notification_cooldown.dart';
import 'package:eswaini_destop_app/ux/utils/sessionManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';
import '../../../platform/utils/isar_manager.dart';
import '../../views/components/dialogs/windows_notification_popup.dart';
import 'app.dart';

class StockMonitorService {
  static final isar = IsarService.db;
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();
  static Timer? _timer;

  // In-memory cache for notified products (still useful for current session)
  static final Set<int> _lowStockNotified = {};
  static final Set<int> _outOfStockNotified = {};

  // Settings cache
  static NotificationSettings? _settings;

  // Stream for low stock count
  static final StreamController<int> _lowStockCountController =
  StreamController<int>.broadcast();

  // Current low stock count
  static int _currentLowStockCount = 0;

  // Stream for out of stock count
  static final StreamController<int> _outOfStockCountController =
  StreamController<int>.broadcast();
  static final WindowsNotification _winNotifyPlugin =
  WindowsNotification(applicationId: "com.example.counterpro");
  static int _currentOutOfStockCount = 0;

  // Global context for showing dialogs on Windows
  static BuildContext? _globalContext;

  // Track active dialogs to prevent multiple popups
  static bool _isDialogShowing = false;
  static bool _enablePopupAlerts = true;

  /// Stream to listen for low stock count changes
  static Stream<int> get lowStockCountStream => _lowStockCountController.stream;

  /// Stream to listen for out of stock count changes
  static Stream<int> get outOfStockCountStream => _outOfStockCountController.stream;

  /// Get current low stock count
  static int get currentLowStockCount => _currentLowStockCount;

  static bool get enablePopupAlerts => _enablePopupAlerts;

  /// Get current out of stock count
  static int get currentOutOfStockCount => _currentOutOfStockCount;

  /// Get total alerts count (low stock + out of stock)
  static int get totalAlertsCount => _currentLowStockCount + _currentOutOfStockCount;

  /// Set global context for Windows dialogs
  static void setGlobalContext(BuildContext context) {
    _globalContext = context;
  }

  static Future<void> init() async {
    // Initialize or load notification settings
    await _initSettings();

    // Initial stock count
    await _updateStockCounts();

    // Android, macOS, Linux initialization
    if (!Platform.isWindows) {

      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwin = DarwinInitializationSettings();
      const linux = LinuxInitializationSettings(
        defaultActionName: 'Open notification',
      );

      final settings = InitializationSettings(
        android: android,
        macOS: darwin,
        linux: linux,
      );

      await _notifications.initialize(settings);
    }
  }

  static Future<void> _initSettings() async {
    // Try to load existing settings
    _settings = await isar.notificationSettings.where().findFirst();

    // If no settings exist, create default
    if (_settings == null) {
      _settings = NotificationSettings();
      await isar.writeTxn(() async {
        await isar.notificationSettings.put(_settings!);
      });
    }
  }

  static Future<void> _updateStockCounts() async {
    final products = await isar.products.where().findAll();

    int lowStockCount = 0;
    int outOfStockCount = 0;

    print("📦 Total products found: ${products.length}");

    for (var product in products) {
      if (!product.isActive) {
        print("⏭️ Product ${product.name} is inactive - skipping");
        continue;
      }

      final isOutOfStock = product.stockQuantity <= 0;
      final isLowStock = product.stockQuantity <= product.lowStockThreshold;

      print("📊 Product: ${product.name}");
      print("   Stock: ${product.stockQuantity}");
      print("   Threshold: ${product.lowStockThreshold}");
      print("   Is Low Stock: $isLowStock");
      print("   Is Out of Stock: $isOutOfStock");

      if (product.stockQuantity <= 0) {
        outOfStockCount++;
        print("   ➕ Out of stock count: $outOfStockCount");
      } else if (product.stockQuantity <= product.lowStockThreshold) {
        lowStockCount++;
        print("   ➕ Low stock count: $lowStockCount");
      }
    }

    print("🎯 Final counts - Low Stock: $lowStockCount, Out of Stock: $outOfStockCount");

    // Update low stock count
    if (_currentLowStockCount != lowStockCount) {
      print("🔄 Low stock count changed from $_currentLowStockCount to $lowStockCount");
      _currentLowStockCount = lowStockCount;
      _lowStockCountController.add(lowStockCount);
    } else {
      print("✅ Low stock count unchanged: $_currentLowStockCount");
    }

    // Update out of stock count
    if (_currentOutOfStockCount != outOfStockCount) {
      _currentOutOfStockCount = outOfStockCount;
      _outOfStockCountController.add(outOfStockCount);
    }
  }

  /// Get list of low stock products
  static Future<List<Product>> getLowStockProducts() async {
    final products = await isar.products.where().findAll();
    return products.where((product) =>
    product.isActive &&
        product.stockQuantity > 0 &&
        product.stockQuantity <= product.lowStockThreshold
    ).toList();
  }

  /// Get list of out of stock products
  static Future<List<Product>> getOutOfStockProducts() async {
    final products = await isar.products.where().findAll();
    return products.where((product) =>
    product.isActive &&
        product.stockQuantity <= 0
    ).toList();
  }

  /// Get all products with stock issues
  static Future<List<Product>> getProductsWithStockIssues() async {
    final products = await isar.products.where().findAll();
    return products.where((product) =>
    product.isActive &&
        (product.stockQuantity <= 0 ||
            product.stockQuantity <= product.lowStockThreshold)
    ).toList();
  }

  static void startMonitoring() {
    _timer?.cancel();
    // Use the stored check interval
    final interval = _settings?.checkIntervalSeconds ?? 30;
    _timer = Timer.periodic(Duration(seconds: interval), (_) async {
      await checkStock();
    });
  }

  static Future<void> checkStock() async {
    print("🔍 Running stock check...");
    print("🔍 ${StockMonitorService.enablePopupAlerts}");

    // Reload settings in case they were updated
    _settings = await isar.notificationSettings.where().findFirst();

    // Check if notifications are enabled globally
    if (_settings == null || !_settings!.enableNotifications || SessionManager().isCashier) {
      print("⚠️ Notifications are disabled");
      return;
    }

    final products = await isar.products.where().findAll();
    print("📦 Found ${products.length} products");

    // Update counts first
    await _updateStockCounts();

    for (var product in products) {
      if (!product.isActive) continue;

      final isOutOfStock = product.stockQuantity <= 0;
      final isLowStock = product.stockQuantity <= product.lowStockThreshold;

      if (isOutOfStock) {
        // Check if out of stock alerts are enabled
        if (_settings!.enableOutOfStockAlerts &&
            !_outOfStockNotified.contains(product.id)) {

          // Check cooldown before showing notification
          if (await _isCooldownExpired(product.id)) {
            _outOfStockNotified.add(product.id);
            await _showNotification(
              title: "Out of Stock 🚫",
              body: "${product.name} is finished!",
              productId: product.id,
              product: product,
            );
          }
        }
      } else if (isLowStock) {
        // Check if low stock alerts are enabled
        if (_settings!.enableLowStockAlerts &&
            !_lowStockNotified.contains(product.id)) {

          // Check cooldown before showing notification
          if (await _isCooldownExpired(product.id)) {
            _lowStockNotified.add(product.id);
            await _showNotification(
              title: "Low Stock ⚠️",
              body: "${product.name} is running low (${product.stockQuantity} left)",
              productId: product.id,
              product: product,
            );
          }
        }
      } else {
        _lowStockNotified.remove(product.id);
        _outOfStockNotified.remove(product.id);
      }
    }
  }

  static Future<bool> _isCooldownExpired(int productId) async {
    // Check if we're in quiet mode
    if (_settings?.quietMode == true && _isInQuietHours()) {
      return false;
    }

    // Check cooldown from database
    final cooldown = await isar.notificationCooldowns.where().idEqualTo(productId).findFirst();

    if (cooldown == null) {
      // No previous notification, allow it
      return true;
    }

    final timeSinceLast = DateTime.now().difference(cooldown.lastNotificationTime);
    final cooldownMinutes = _settings?.cooldownMinutes ?? 5;

    return timeSinceLast.inMinutes >= cooldownMinutes;
  }

  static bool _isInQuietHours() {
    if (_settings == null) return false;

    final now = DateTime.now();
    final currentHour = now.hour;
    final startHour = _settings!.quietModeStartHour;
    final endHour = _settings!.quietModeEndHour;

    if (startHour <= endHour) {
      // Normal range (e.g., 22 to 7)
      return currentHour >= startHour && currentHour < endHour;
    } else {
      // Overnight range (e.g., 22 to 7 crossing midnight)
      return currentHour >= startHour || currentHour < endHour;
    }
  }

  static Future<void> _showNotification({
    required String title,
    required String body,
    required int productId,
    Product? product,
  }) async {
    // Check quiet mode again
    if (_settings?.quietMode == true && _isInQuietHours()) {
      return;
    }

    // Save cooldown to database
    await isar.writeTxn(() async {
      final cooldown = NotificationCooldown(
        id: productId,
        lastNotificationTime: DateTime.now(),
      );
      await isar.notificationCooldowns.put(cooldown);
    });
    if (_settings?.enablePopupAlerts == true) {
    // Platform-specific notification handling
    if (Platform.isWindows) {
      // Show dialog for Windows

      NotificationMessage message =
         NotificationMessage.fromPluginTemplate(
           "$title\n",
        "stock_${productId}", // unique id
        "${product?.name ?? 'Product'} is running low (${product?.stockQuantity ?? 0} left)",
      );

      _winNotifyPlugin.showNotificationPluginTemplate(message);
    } else if (Platform.isAndroid) {
      const androidDetails = AndroidNotificationDetails(
        'stock_channel',
        'Stock Alerts',
        importance: Importance.max,
        priority: Priority.high,
      );

      final details = NotificationDetails(android: androidDetails);
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
      );
    } else if (Platform.isMacOS) {
      const macDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(macOS: macDetails);
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
      );
    }
    }else {
      // fallback → silent log or badge update
      print("🔕 Popup disabled: $title - $body");
    }
  }

  // In stock_monitor.dart


  static void stop() {
    _timer?.cancel();
  }

  static Future<void> setEnablePopupAlerts(bool enabled) async {
    if (_settings == null) await _initSettings();


    _enablePopupAlerts = enabled;
    _settings!.enablePopupAlerts = _enablePopupAlerts;

    await updateSettings(_settings!);
  }


  static void dispose() {
    stop();
    _lowStockCountController.close();
    _outOfStockCountController.close();
  }

  // Settings management methods

  static Future<NotificationSettings> getSettings() async {
    return _settings ?? await _initSettings() as NotificationSettings;
  }

  static Future<void> updateSettings(NotificationSettings newSettings) async {
    await isar.writeTxn(() async {
      await isar.notificationSettings.put(newSettings);
    });
    _settings = newSettings;

    // Restart monitoring if interval changed
    if (_timer != null) {
      startMonitoring();
    }
  }

  static Future<void> setEnableNotifications(bool enabled) async {
    if (_settings == null) await _initSettings();
    _settings!.enableNotifications = enabled;
    await updateSettings(_settings!);

    if (!enabled && !Platform.isWindows) {
      await _notifications.cancelAll();
    }
  }

  static Future<void> setEnableLowStockAlerts(bool enabled) async {
    if (_settings == null) await _initSettings();
    _settings!.enableLowStockAlerts = enabled;
    await updateSettings(_settings!);

    if (!enabled) {
      _lowStockNotified.clear();
    }
  }

  static Future<void> setEnableOutOfStockAlerts(bool enabled) async {
    if (_settings == null) await _initSettings();
    _settings!.enableOutOfStockAlerts = enabled;
    await updateSettings(_settings!);

    if (!enabled) {
      _outOfStockNotified.clear();
    }
  }

  static Future<void> setCheckInterval(int seconds) async {
    if (_settings == null) await _initSettings();
    _settings!.checkIntervalSeconds = seconds;
    await updateSettings(_settings!);
  }

  static Future<void> setCooldownMinutes(int minutes) async {
    if (_settings == null) await _initSettings();
    _settings!.cooldownMinutes = minutes;
    await updateSettings(_settings!);
  }

  static Future<void> setQuietMode(bool enabled, {int? startHour, int? endHour}) async {
    if (_settings == null) await _initSettings();
    _settings!.quietMode = enabled;
    if (startHour != null) _settings!.quietModeStartHour = startHour;
    if (endHour != null) _settings!.quietModeEndHour = endHour;
    await updateSettings(_settings!);
  }
}