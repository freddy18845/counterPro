import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import '../models/shared/signOnResponse.dart';
import '../models/shared/terminal_cred.dart';
import '../models/terminal_sign_on_response.dart';


class SecureStorageService {
  final _storage = const FlutterSecureStorage();
  static const _keyToken = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyTokenExpiry = 'token_expiry';
  static const _keySignOnResponse = 'sign_on_response';
  static const String _credentialsFileName = 'terminal_simple.json';

  // Improved encryption using XOR with base64 encoding
  static String _simpleEncrypt(String data, String password) {
    try {
      // Generate key from password using SHA-256
      final keyBytes = sha256.convert(utf8.encode(password)).bytes;
      final dataBytes = utf8.encode(data);
      final result = Uint8List(dataBytes.length);

      // XOR each byte with corresponding key byte
      for (int i = 0; i < dataBytes.length; i++) {
        result[i] = dataBytes[i] ^ keyBytes[i % keyBytes.length];
      }

      // Convert to base64 to ensure safe string handling
      return base64.encode(result);
    } catch (e) {
      if (kDebugMode) print('Encryption error: $e');
      rethrow;
    }
  }

  // Improved decryption with base64 decoding
  static String _simpleDecrypt(String encryptedData, String password) {
    try {
      // Decode from base64
      final encryptedBytes = base64.decode(encryptedData);

      // Generate key from password using SHA-256
      final keyBytes = sha256.convert(utf8.encode(password)).bytes;
      final result = Uint8List(encryptedBytes.length);

      // XOR each byte with corresponding key byte
      for (int i = 0; i < encryptedBytes.length; i++) {
        result[i] = encryptedBytes[i] ^ keyBytes[i % keyBytes.length];
      }

      // Convert back to UTF-8 string
      return utf8.decode(result);
    } catch (e) {
      if (kDebugMode) print('Decryption error: $e');
      rethrow;
    }
  }

  // Get master password with better fallback
  static String _getMasterPassword() {
    const envKey = String.fromEnvironment('MASTER_KEY');
    if (envKey.isNotEmpty) {
      if (kDebugMode) print('Master Key Successfully Retrieved');
      return envKey;
    }

    // Default fallback key for debug mode
    const fallbackKey = 'debug_only_master_key_32_bytes_long!!';
    if (kDebugMode) print('Using fallback key');
    return fallbackKey;
  }

  // Save token securely
  Future<void> saveAuthToken({required String token, required DateTime expiryTime}) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyTokenExpiry, value: expiryTime.toIso8601String());
  }

  // Retrieve token securely
  Future<String?> getAuthToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Retrieve token expiry time
  Future<DateTime?> getTokenExpiry() async {
    String? expiryString = await _storage.read(key: _keyTokenExpiry);
    return expiryString != null ? DateTime.parse(expiryString) : null;
  }

  // Delete token securely
  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyTokenExpiry);
  }

  // Check if token exists and is valid
  Future<bool> isTokenValid() async {
    String? token = await _storage.read(key: _keyToken);
    DateTime? expiryTime = await getTokenExpiry();

    if (token == null || expiryTime == null || DateTime.now().isAfter(expiryTime)) {
      return false;
    }
    return true;
  }

  // Activation Methods
  Future<TerminalSignOnResponse?> getSignOnFromStorage() async {
    String? storedSignOnResponseStr = await _storage.read(key: _keySignOnResponse);
    if (null != storedSignOnResponseStr) {
      TerminalSignOnResponse signOnResponse =
      TerminalSignOnResponse.fromJson(jsonDecode(storedSignOnResponseStr));
      return signOnResponse;
    }
    return null;
  }


  Future<void> saveSignOnResponseToStorage({required TerminalSignOnResponse signOnResponse}) async {
    await _storage.write(key: _keySignOnResponse, value: signOnResponse.toRawJson());
  }

  // Store credentials with improved error handling
  static Future<bool> storeCredentials(TerminalCredentials credentials) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_credentialsFileName');

      // Convert credentials to JSON
      final jsonData = jsonEncode(credentials.toJson());
      if (kDebugMode) print('Storing credentials, JSON length: ${jsonData.length}');

      // Encrypt the JSON data (now returns base64 string)
      final encryptedData = _simpleEncrypt(jsonData, _getMasterPassword());

      // Write encrypted string to file
      await file.writeAsString(encryptedData);

      // Create a verification file with a hash of the original data
      final verificationFile = File('${directory.path}/simple_verification.txt');
      final dataHash = sha256.convert(utf8.encode(jsonData)).toString();
      await verificationFile.writeAsString(dataHash);

      if (kDebugMode) print('Credentials stored successfully');
      return true;
    } catch (e) {
      if (kDebugMode) print('Error storing credentials: $e');
      return false;
    }
  }

  // Retrieve credentials with improved error handling
  static Future<TerminalCredentials?> retrieveCredentials() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_credentialsFileName');

      if (!await file.exists()) {
        if (kDebugMode) print('Credentials file not found');
        return null;
      }

      // Read encrypted data as string
      final encryptedData = await file.readAsString();
      if (kDebugMode) print('Read encrypted data, length: ${encryptedData.length}');

      // Decrypt the data
      final jsonData = _simpleDecrypt(encryptedData, _getMasterPassword());

      // Verify integrity if verification file exists
      final verificationFile = File('${directory.path}/simple_verification.txt');
      if (await verificationFile.exists()) {
        final storedHash = await verificationFile.readAsString();
        final calculatedHash = sha256.convert(utf8.encode(jsonData)).toString();

        if (storedHash != calculatedHash) {
          if (kDebugMode) print('Warning: Data integrity check failed');
          // Delete corrupted files and return null
          await _clearCorruptedFiles();
          return null;
        }
      }

      // Parse JSON into credentials
      final Map<String, dynamic> credentialsMap = jsonDecode(jsonData);
      return TerminalCredentials.fromJson(credentialsMap);
    } catch (e) {
      if (kDebugMode) print('Error retrieving credentials: $e');
      // Clear potentially corrupted files
      await _clearCorruptedFiles();
      return null;
    }
  }

  // Helper method to clear corrupted files
  static Future<void> _clearCorruptedFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_credentialsFileName');
      final verificationFile = File('${directory.path}/simple_verification.txt');

      if (await file.exists()) {
        await file.delete();
        if (kDebugMode) print('Deleted corrupted credentials file');
      }

      if (await verificationFile.exists()) {
        await verificationFile.delete();
        if (kDebugMode) print('Deleted corrupted verification file');
      }
    } catch (e) {
      if (kDebugMode) print('Error clearing corrupted files: $e');
    }
  }


  // Deactivate terminal by deleting files
  static Future<bool> deactivateTerminal() async {
    try {
      // Clear all secure storage
      const storage = FlutterSecureStorage();
      await storage.deleteAll();

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_credentialsFileName');
      final verificationFile = File('${directory.path}/simple_verification.txt');

      if (await file.exists()) {
        await file.delete();
      }

      if (await verificationFile.exists()) {
        await verificationFile.delete();
      }

      if (kDebugMode) print('Terminal deactivated successfully');
      return true;
    } catch (e) {
      if (kDebugMode) print('Error deactivating terminal: $e');
      return false;
    }
  }

  // Check if terminal is activated
  static Future<bool> isTerminalActivated() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_credentialsFileName');
      return await file.exists();
    } catch (e) {
      if (kDebugMode) print('Error checking activation: $e');
      return false;
    }
  }

  // Retrieve refresh token securely
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }


}