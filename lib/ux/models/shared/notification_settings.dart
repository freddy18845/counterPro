import 'package:isar/isar.dart';

part 'notification_settings.g.dart';

@collection
class NotificationSettings {
  Id id = 0; // Use single record with id=0

  late bool enableNotifications;
  late bool enableLowStockAlerts;
  late bool enableOutOfStockAlerts;
  late bool enablePopupAlerts;
  late int checkIntervalSeconds; // 15, 30, 60, etc.
  late int cooldownMinutes; // Cooldown period between notifications for same product
  late bool quietMode; // Silence all notifications during quiet hours
  late int quietModeStartHour; // Quiet hours start (0-23)
  late int quietModeEndHour;   // Quiet hours end (0-23)

  NotificationSettings({
    this.enableNotifications = true,
    this.enableLowStockAlerts = true,
    this.enableOutOfStockAlerts = true,
    this.checkIntervalSeconds = 30,
    this.cooldownMinutes = 5,
    this.quietMode = false,
    this. enablePopupAlerts = true,
    this.quietModeStartHour = 22, // 10 PM
    this.quietModeEndHour = 7,    // 7 AM
  });
}