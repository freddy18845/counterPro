// lib/platform/utils/performance_monitor.dart
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class PerformanceMonitor {
  static void logMemory(String tag) {
    if (kDebugMode) {
      developer.Timeline.instantSync(tag);
      debugPrint('📊 $tag — check DevTools Memory tab');
    }
  }
}