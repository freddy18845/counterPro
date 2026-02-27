import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DebugConfig {
  final String? baseUrl;
  final String? acquirerId;
  final String? terminalCapabilities;
  final String? additionalTerminalCapabilities;
  final bool isDebugMode;

  DebugConfig({
    this.baseUrl,
    this.acquirerId,
    this.terminalCapabilities,
    this.additionalTerminalCapabilities,
    this.isDebugMode = false,
  });

  bool get useDebug => isDebugMode;
  bool get useDebugBaseUrl => isDebugMode && (baseUrl != null && baseUrl!.isNotEmpty);
  bool get useDebugAcquirerId => isDebugMode && (acquirerId != null && acquirerId!.isNotEmpty);
  bool get useDebugTerminalCap=>
      isDebugMode && (terminalCapabilities != null && terminalCapabilities!.isNotEmpty);
  bool get useDebugAdditionalCap =>
      isDebugMode &&
          (additionalTerminalCapabilities != null && additionalTerminalCapabilities!.isNotEmpty);

  factory DebugConfig.fromJson(Map<String, dynamic> json) {
    return DebugConfig(
      baseUrl: json[DebugKeys.baseUrl] as String?,
      acquirerId: json[DebugKeys.acquirerId] as String?,
      terminalCapabilities: json[DebugKeys.terminalCapabilities] as String?,
      additionalTerminalCapabilities: json[DebugKeys.additionalTerminalCapabilities] as String?,
      isDebugMode: json[DebugKeys.debugModeEnabled] as bool? ?? false,
    );
  }

  /// Creates a JSON map from a DebugConfig instance.
  Map<String, dynamic> toJson() {
    return {
      DebugKeys.baseUrl: baseUrl,
      DebugKeys.acquirerId: acquirerId,
      DebugKeys.terminalCapabilities: terminalCapabilities,
      DebugKeys.additionalTerminalCapabilities: additionalTerminalCapabilities,
      DebugKeys.debugModeEnabled: isDebugMode,
    };
  }
}

class DebugConfigStorage {
  static const _storage = FlutterSecureStorage();

  /// Retrieves the complete debug configuration as a structured object.
  static Future<DebugConfig> retrieveAppDebugConfig() async {
    try {
      final jsonString = await _storage.read(key: DebugKeys.configKey);
      if (jsonString == null) {
        return DebugConfig();
      }

      final Map<String, dynamic> config = jsonDecode(jsonString);
      return DebugConfig.fromJson(config);
    } catch (e) {
      if (kDebugMode) print('Error retrieving app config: $e');
      return DebugConfig();
    }
  }

  /// Stores the complete debug configuration.
  static Future<bool> storeAppConfig({
    String? baseUrl,
    String? acquirerId,
    String? terminalCapabilities,
    String? additionalTerminalCapabilities,
    bool? debugModeEnabled,
  }) async {
    try {
      final existingConfig = await retrieveAppDebugConfig();

      final updatedConfig = DebugConfig(
        baseUrl: baseUrl ?? existingConfig.baseUrl,
        acquirerId: acquirerId ?? existingConfig.acquirerId,
        terminalCapabilities: terminalCapabilities ?? existingConfig.terminalCapabilities,
        additionalTerminalCapabilities:
        additionalTerminalCapabilities ?? existingConfig.additionalTerminalCapabilities,
        isDebugMode: debugModeEnabled ?? existingConfig.isDebugMode,
      );

      final jsonString = jsonEncode(updatedConfig.toJson());
      await _storage.write(key: DebugKeys.configKey, value: jsonString);
      return true;
    } catch (e) {
      if (kDebugMode) print('Error storing app config: $e');
      return false;
    }
  }

  /// Clears the stored debug configuration.
  static Future<bool> clearConfig() async {
    try {
      await _storage.delete(key: DebugKeys.configKey);
      return true;
    } catch (e) {
      if (kDebugMode) print('Error clearing config: $e');
      return false;
    }
  }

  /// A simple method to check if debug mode is currently enabled.
  static Future<bool> isDebuggingEnabled() async {
    final config = await retrieveAppDebugConfig();
    return config.isDebugMode;
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
