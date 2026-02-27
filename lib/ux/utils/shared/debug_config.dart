import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class DebugConfigStorage {
  static const _storage = FlutterSecureStorage();

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
        DebugKeys.baseUrl: baseUrl ?? existingConfig[DebugKeys.baseUrl],
        DebugKeys.acquirerId: acquirerId ?? existingConfig[DebugKeys.acquirerId],
        DebugKeys.terminalCapabilities:
        terminalCapabilities ?? existingConfig[DebugKeys.terminalCapabilities],
        DebugKeys.additionalTerminalCapabilities: additionalTerminalCapabilities ??
            existingConfig[DebugKeys.additionalTerminalCapabilities],
        DebugKeys.debugModeEnabled: debugModeEnabled ?? existingConfig[DebugKeys.debugModeEnabled],
      };

      final jsonString = jsonEncode(configData);
      await _storage.write(key: DebugKeys.configKey, value: jsonString);
      return true;
    } catch (e) {
      if (kDebugMode) print('Error storing app config: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> retrieveAppDebugConfig() async {
    try {
      final jsonString = await _storage.read(key: DebugKeys.configKey);
      if (jsonString == null) {
        return {
          DebugKeys.baseUrl: null,
          DebugKeys.acquirerId: null,
          DebugKeys.terminalCapabilities: null,
          DebugKeys.additionalTerminalCapabilities: null,
          DebugKeys.debugModeEnabled: false,
        };
      }

      final config = jsonDecode(jsonString) as Map<String, dynamic>;
      return {
        DebugKeys.baseUrl: config[DebugKeys.baseUrl],
        DebugKeys.acquirerId: config[DebugKeys.acquirerId],
        DebugKeys.terminalCapabilities: config[DebugKeys.terminalCapabilities],
        DebugKeys.additionalTerminalCapabilities: config[DebugKeys.additionalTerminalCapabilities],
        DebugKeys.debugModeEnabled: config[DebugKeys.debugModeEnabled] ?? false,
      };
    } catch (e) {
      if (kDebugMode) print('Error retrieving app config: $e');
      return {
        DebugKeys.baseUrl: null,
        DebugKeys.acquirerId: null,
        DebugKeys.terminalCapabilities: null,
        DebugKeys.additionalTerminalCapabilities: null,
        DebugKeys.debugModeEnabled: false,
      };
    }
  }

  static Future<bool> clearConfig() async {
    try {
      await _storage.delete(key: DebugKeys.configKey);
      return true;
    } catch (e) {
      if (kDebugMode) print('Error clearing config: $e');
      return false;
    }
  }
}

class DebugKeys {
  static const String configKey = 'app_debug_config';
  static const String baseUrl = 'baseUrl';
  static const String acquirerId = 'acquirerId';
  static const String terminalCapabilities = 'terminalCapabilities';
  static const String additionalTerminalCapabilities = 'additionalTerminalCapabilities';
  static const String debugModeEnabled = 'debugModeEnabled';
}
