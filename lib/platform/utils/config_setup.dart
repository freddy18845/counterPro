import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DebugConfigStorage {
  static const _storage = FlutterSecureStorage();

  /// ✅ Save configuration safely (with defaults)
  static Future<bool> storeAppConfig({
    String? baseUrl,
    String? acquirerId,
    String? terminalCapabilities,
    String? additionalTerminalCapabilities,
    bool? debugModeEnabled,
  }) async {
    try {
      final existingConfig = await retrieveAppDebugConfig();

      final configData = <String, dynamic>{
        DebugKeys.baseUrl: baseUrl ?? existingConfig[DebugKeys.baseUrl] ?? '',
        DebugKeys.acquirerId: acquirerId ?? existingConfig[DebugKeys.acquirerId] ?? '',
        DebugKeys.terminalCapabilities:
        terminalCapabilities ?? existingConfig[DebugKeys.terminalCapabilities] ?? '',
        DebugKeys.additionalTerminalCapabilities:
        additionalTerminalCapabilities ??
            existingConfig[DebugKeys.additionalTerminalCapabilities] ??
            '',
        DebugKeys.debugModeEnabled:
        debugModeEnabled ?? existingConfig[DebugKeys.debugModeEnabled] ?? false,
      };

      final jsonString = jsonEncode(configData);
      await _storage.write(key: DebugKeys.configKey, value: jsonString);

      if (kDebugMode) print('✅ App config saved: $configData');
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ Error storing app config: $e');
      return false;
    }
  }

  /// ✅ Retrieve configuration safely (never returns null)
  static Future<Map<String, dynamic>> retrieveAppDebugConfig() async {
    try {
      final jsonString = await _storage.read(key: DebugKeys.configKey);
      if (jsonString == null) {
        return _emptyConfig;
      }

      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) return _emptyConfig;

      return {
        DebugKeys.baseUrl: decoded[DebugKeys.baseUrl] ?? '',
        DebugKeys.acquirerId: decoded[DebugKeys.acquirerId] ?? '',
        DebugKeys.terminalCapabilities: decoded[DebugKeys.terminalCapabilities] ?? '',
        DebugKeys.additionalTerminalCapabilities:
        decoded[DebugKeys.additionalTerminalCapabilities] ?? '',
        DebugKeys.debugModeEnabled: decoded[DebugKeys.debugModeEnabled] ?? false,
      };
    } catch (e) {
      if (kDebugMode) print('❌ Error retrieving app config: $e');
      return _emptyConfig;
    }
  }

  /// ✅ Clear stored config
  static Future<bool> clearConfig() async {
    try {
      await _storage.delete(key: DebugKeys.configKey);
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ Error clearing config: $e');
      return false;
    }
  }

  /// ✅ Default empty config
  static const Map<String, dynamic> _emptyConfig = {
    DebugKeys.baseUrl: '',
    DebugKeys.acquirerId: '',
    DebugKeys.terminalCapabilities: '',
    DebugKeys.additionalTerminalCapabilities: '',
    DebugKeys.debugModeEnabled: false,
  };
}

class DebugKeys {
  static const String configKey = 'app_debug_config';
  static const String baseUrl = 'baseUrl';
  static const String acquirerId = 'acquirerId';
  static const String terminalCapabilities = 'terminalCapabilities';
  static const String additionalTerminalCapabilities = 'additionalTerminalCapabilities';
  static const String debugModeEnabled = 'debugModeEnabled';
}
