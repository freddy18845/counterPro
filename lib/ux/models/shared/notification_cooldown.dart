import 'package:isar/isar.dart';

part 'notification_cooldown.g.dart';

@collection
class NotificationCooldown {
  Id id; // This will be the product ID
  late DateTime lastNotificationTime;

  NotificationCooldown({
    required this.id,
    required this.lastNotificationTime,
  });
}