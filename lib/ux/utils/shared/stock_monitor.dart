import 'dart:async';
import 'dart:io';
import 'package:eswaini_destop_app/ux/models/shared/product.dart';
import 'package:eswaini_destop_app/ux/models/shared/notification_settings.dart';
import 'package:eswaini_destop_app/ux/models/shared/notification_cooldown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';

import '../../../platform/utils/isar_manager.dart';

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

  static int _currentOutOfStockCount = 0;

  // Global context for showing dialogs on Windows
  static BuildContext? _globalContext;

  // Track active dialogs to prevent multiple popups
  static bool _isDialogShowing = false;

  /// Stream to listen for low stock count changes
  static Stream<int> get lowStockCountStream => _lowStockCountController.stream;

  /// Stream to listen for out of stock count changes
  static Stream<int> get outOfStockCountStream => _outOfStockCountController.stream;

  /// Get current low stock count
  static int get currentLowStockCount => _currentLowStockCount;

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

    // Reload settings in case they were updated
    _settings = await isar.notificationSettings.where().findFirst();

    // Check if notifications are enabled globally
    if (_settings == null || !_settings!.enableNotifications) {
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

    // Platform-specific notification handling
    if (Platform.isWindows) {
      // Show dialog for Windows
      await _showWindowsDialog(title, body, product);
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
    } else if (Platform.isLinux) {
      const linuxDetails = LinuxNotificationDetails();
      final details = NotificationDetails(linux: linuxDetails);
      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
      );
    }
  }

  // In stock_monitor.dart
  static Future<void> _showWindowsDialog(String title, String body, Product? product) async {
    // Check if a dialog is already showing to prevent multiple popups
    if (_isDialogShowing) return;

    // Check if we have a valid context
    if (_globalContext == null) {
      print("Windows Alert: $title - $body");
      print("No global context set. Make sure to call StockMonitorService.setGlobalContext()");
      return;
    }

    // Check if context is still valid
    if (!_globalContext!.mounted) {
      print("Context is not mounted. Cannot show dialog.");
      return;
    }

    _isDialogShowing = true;

    try {
      // Use WidgetsBinding to ensure we're on the right frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_globalContext != null && _globalContext!.mounted && !_isDialogShowing) {
          showDialog(
            context: _globalContext!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      title.contains("Out of Stock")
                          ? Icons.error_outline
                          : Icons.warning_amber_rounded,
                      color: title.contains("Out of Stock")
                          ? Colors.red
                          : Colors.orange,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: title.contains("Out of Stock")
                              ? Colors.red
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(body, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 12),
                    if (product != null) ...[
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        "Product Details:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("• Current Stock: ${product.stockQuantity}"),
                      Text("• Threshold: ${product.lowStockThreshold}"),
                      if (product.stockQuantity <= 0)
                        const Text(
                          "• Status: OUT OF STOCK",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else if (product.stockQuantity <= product.lowStockThreshold)
                        const Text(
                          "• Status: LOW STOCK",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "This product requires immediate attention",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _isDialogShowing = false;
                    },
                    child: const Text("Later"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _isDialogShowing = false;
                      // Navigate to product details
                      if (_globalContext != null && product != null) {
                        // Add your navigation logic here
                        print("View product: ${product.name}");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: title.contains("Out of Stock")
                          ? Colors.red
                          : Colors.orange,
                    ),
                    child: const Text("View Product"),
                  ),
                ],
              );
            },
          ).then((_) {
            _isDialogShowing = false;
          });
        } else {
          _isDialogShowing = false;
        }
      });
    } catch (e) {
      print("Error showing Windows dialog: $e");
      _isDialogShowing = false;
    }
  }

  static void stop() {
    _timer?.cancel();
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