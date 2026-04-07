// ─────────────────────────────────────────────────────────────
// ── API SERVICE (core HTTP client) ───────────────────────────
// ─────────────────────────────────────────────────────────────
import 'dart:convert';
import 'dart:io';
import 'package:eswaini_destop_app/ux/utils/shared/api_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/shared/api_response.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const Duration _timeout = Duration(seconds: 30);

  // ── Build headers ─────────────────────────────────────────
  // lib/platform/services/api_service.dart


  Future<Map<String, String>> _headers() async {
    final token  = await ApiConfig.getToken();
    final apiKey = await ApiConfig.getApiKey();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // ← trim again just to be safe
      if (apiKey != null) 'X-API-Key': apiKey.trim(),
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── GET ───────────────────────────────────────────────────
  Future<ApiResponse<Map<String, dynamic>>> get(
      String endpoint) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();
      final headers = await _headers();
      final uri = Uri.parse('$baseUrl$endpoint');

      debugPrint('🌐 GET $uri');
      debugPrint('🌐 Header $headers');

      final response = await http
          .get(uri, headers: headers)
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponse.error('HTTP error: $e');
    } catch (e) {
      return ApiResponse.error('Request failed: $e');
    }
  }

  // ── POST ──────────────────────────────────────────────────
  Future<ApiResponse<Map<String, dynamic>>> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();
      final headers = await _headers();
      final uri = Uri.parse('$baseUrl$endpoint');

      debugPrint('🌐 POST $uri');

      final response = await http
          .post(uri,
          headers: headers, body: jsonEncode(body))
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } catch (e) {
      return ApiResponse.error('Request failed: $e');
    }
  }

  // ── PUT ───────────────────────────────────────────────────
  Future<ApiResponse<Map<String, dynamic>>> put(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();
      final headers = await _headers();
      final uri = Uri.parse('$baseUrl$endpoint');

      debugPrint('🌐 PUT $uri');

      final response = await http
          .put(uri,
          headers: headers, body: jsonEncode(body))
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } catch (e) {
      return ApiResponse.error('Request failed: $e');
    }
  }

  // ── DELETE ────────────────────────────────────────────────
  Future<ApiResponse<Map<String, dynamic>>> delete(
      String endpoint) async {
    try {
      final baseUrl = await ApiConfig.getBaseUrl();
      final headers = await _headers();
      final uri = Uri.parse('$baseUrl$endpoint');

      debugPrint('🌐 DELETE $uri');

      final response = await http
          .delete(uri, headers: headers)
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } catch (e) {
      return ApiResponse.error('Request failed: $e');
    }
  }

  // ── Handle response ───────────────────────────────────────
  ApiResponse<Map<String, dynamic>> _handleResponse(
      http.Response response) {
    debugPrint('📡 ${response.statusCode} ${response.request?.url}');

    try {
      final body = jsonDecode(response.body)
      as Map<String, dynamic>;

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return ApiResponse.success(body,
            statusCode: response.statusCode);
      }

      // handle common errors
      final message = body['message'] ??
          body['error'] ??
          'Server error ${response.statusCode}';

      if (response.statusCode == 401) {
        ApiConfig.clearToken(); // token expired
        return ApiResponse.error('Session expired. Please log in again.',
            statusCode: 401);
      }

      return ApiResponse.error(message.toString(),
          statusCode: response.statusCode);
    } catch (_) {
      return ApiResponse.error(
          'Invalid server response',
          statusCode: response.statusCode);
    }
  }
}

// ─────────────────────────────────────────────────────────────
// ── AUTH SERVICE ─────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────
class AuthApiService {
  final _api = ApiService();

  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
    required String apiKey,
  }) async {
    await ApiConfig.setApiKey(apiKey);

    final response = await _api.post('/auth/login', {
      'email': email,
      'password': password,
    });

    if (response.success && response.data != null) {
      final token = response.data!['token'] as String?;
      if (token != null) {
        await ApiConfig.setToken(token);
      }
    }

    return response;
  }



  Future<ApiResponse<Map<String, dynamic>>>
  refreshToken() async {
    return _api.post('/auth/refresh', {});
  }

  Future<void> logout() async {
    await _api.post('/auth/logout', {});
    await ApiConfig.clearToken();
  }

  Future<ApiResponse<Map<String, dynamic>>> validateApiKey(
      String apiKey) async {

    // ← save first
    await ApiConfig.setApiKey(apiKey.trim());

    // ← then make the request — headers will now include the key
    final response = await _api.get('/auth/validate');

    debugPrint('🔑 Validate response: ${response.success}');
    debugPrint('🔑 Validate error: ${response.error}');
    debugPrint('🔑 Validate data: ${response.data}');

    return response;
  }




  Future<Map<String, dynamic>?> initializePayment({
    required double amount,
    required String email,
  }) async {
    final url = Uri.parse("https://smartcarpark.top/api/payments/initializeCounterProPayment");

    print("📡 Initializing payment with:");
    print("   URL: $url");
    print("   Amount: $amount");
    print("   Email: $email");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "amount": amount,
          "email": email,
        }),
      ).timeout(const Duration(seconds: 30));

      print("📥 Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("📦 Response body: $data");

        if (data['success'] == true) {
          print("✅ Payment initialization successful");
          return data['data']; // contains authorization_url
        } else {
          print("❌ Payment initialization failed: ${data['message']}");
          return null;
        }
      } else if (response.statusCode == 404) {
        print("❌ API endpoint not found (404)");
        print("   Please check if the URL is correct:");
        print("   $url");
        return null;
      } else {
        print("❌ HTTP Error ${response.statusCode}: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Network error: $e");
      return null;
    }
  }



  Future<void> openPaymentPage(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch payment page";
    }
  }

  Future<bool> verifyPayment(String reference) async {
    final url = Uri.parse(
        "https://smartcarpark.top/api/payments/verifyCounterProPayment?reference=$reference");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data['success'] == true;
      }

      return false;

    } catch (e) {
      print("Verification error: $e");
      return false;
    }
  }
}