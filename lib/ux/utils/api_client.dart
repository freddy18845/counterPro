import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../platform/utils/constant.dart';


class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  final http.Client _client = http.Client();
  bool _debugModeEnabled = false;
  File? _logFile;

  ApiClient._internal();

  // Initialize the API client with debug mode from config
  Future<void> initialize(bool isDebugMode) async {
    _debugModeEnabled = isDebugMode;
    if (_debugModeEnabled) {
      await _initializeLogFile();
    }
  }

  //Main Function

  Future<http.Response> post(
      String url, {
        Map<String, String>? headers,
        Object? body,
        Duration timeout = const Duration(seconds: ConstantUtil.apiTimeDuration),
      }) async {
    // 1. Check Connectivity First
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      await _writeToLog('--- POST BLOCKED ---\nURL: $url\nError: No Internet Connection\n');
      throw const SocketException('No Internet Connection'); // Stop execution here
    }

    headers ??= {'Content-Type': 'application/json'};
    final stopwatch = Stopwatch()..start();
    await _logRequest('POST', url, headers, body);

    try {
      final response = await _client
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(timeout);

      stopwatch.stop();
      await _logResponse('POST', response.statusCode, response.body, stopwatch.elapsed);
      return response;
    } catch (e) {
      stopwatch.stop();
      await _writeToLog(
        '--- POST ERROR ---\nURL: $url\nError: $e\nDuration: ${stopwatch.elapsed.inMilliseconds}ms\n',
      );
      rethrow;
    }
  }

  //FIle Logging Methods
  // Initialize log file for debug mode
  Future<void> _initializeLogFile() async {
    try {
      Directory? logDirectory;

      if (Platform.isAndroid) {
        final downloadsDir = Directory('/storage/emulated/0/Download');
        if (await downloadsDir.exists()) {
          logDirectory = Directory('${downloadsDir.path}/ApiLogs');
        }
      }

      if (logDirectory == null) {
        throw Exception("Unable to determine accessible log directory");
      }

      // Create directory if it doesn't exist
      if (!await logDirectory.exists()) {
        await logDirectory.create(recursive: true);
      }

      // Create file with today's date
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _logFile = File('${logDirectory.path}/rise_pay_logs_$today.txt');

      if (!await _logFile!.exists()) {
        await _logFile!.create();
        await _writeToLog('=== API Logs Started: ${DateTime.now().toIso8601String()} ===\n');
      }

      if (kDebugMode) print('Logging to: ${_logFile!.path}');
    } catch (e) {
      if (kDebugMode) print('Error initializing log file: $e');
    }
  }

  // Write log entry to file
  Future<void> _writeToLog(String message) async {
    if (!_debugModeEnabled || _logFile == null) return;
    try {
      final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now());
      final logEntry = '[$timestamp] $message\n';
      await _logFile!.writeAsString(logEntry, mode: FileMode.append);
    } catch (e) {
      if (kDebugMode) print('Error writing to log file: $e');
    }
  }

  // Log API request details
  Future<void> _logRequest(
      String method, String url, Map<String, String>? headers, Object? body) async {
    if (!_debugModeEnabled) return;

    final logMessage = StringBuffer();
    logMessage.writeln('--- $method REQUEST ---');
    logMessage.writeln('URL: $url');

    if (headers != null && headers.isNotEmpty) {
      logMessage.writeln('Headers:');
      headers.forEach((key, value) {
        logMessage.writeln('  $key: $value');
      });
    }
    if (body != null) {
      logMessage.writeln('Body: $body');
    }
    await _writeToLog(logMessage.toString());
  }

  // Log API response details
  Future<void> _logResponse(
      String method, int statusCode, String responseBody, Duration duration) async {
    if (!_debugModeEnabled) return;

    final logMessage = StringBuffer();
    logMessage.writeln('--- $method RESPONSE ---');
    logMessage.writeln('Status Code: $statusCode');
    logMessage.writeln('Duration: ${duration.inMilliseconds}ms');
    logMessage.writeln('Response Body: $responseBody');
    logMessage.writeln(''); // Empty line for separation

    await _writeToLog(logMessage.toString());
  }

  void close() {
    _client.close();
  }
}