import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:flutter/cupertino.dart';
import '../platform/utils/constant.dart';
import '../platform/utils/utils.dart';
import '../ux/Providers/transaction_provider.dart';
import '../ux/models/shared/password_change_request.dart';
import '../ux/models/shared/password_change_response.dart';
import '../ux/models/shared/transaction_query_response.dart';
import '../ux/models/shared/transaction_query_response.dart' hide QueryDateRange;
import '../ux/models/shared/trnsaction_quuery_request.dart' as req;
import '../ux/models/terminal_sign_on_request.dart';
import '../ux/models/terminal_sign_on_response.dart';
import '../ux/utils/api_client.dart';
import '../ux/utils/locator.dart';
import '../ux/utils/secure_storage.dart';
import '../ux/utils/shared/app.dart';

class Repository {
  final SecureStorageService _secureStorageService =
  locator<SecureStorageService>();
  final ApiClient apiClient = locator<ApiClient>();
final  String BASE_URL  = ConstantUtil.defaultUrl;





  String _cleanJsonResponse(String response) {
    // Remove trailing commas that break JSON parsing
    String cleaned = response.replaceAllMapped(
      RegExp(r',\s*([}\]])'),
          (match) => match.group(1)!,
    );

    // Ensure the response is properly formatted JSON
    if (!cleaned.trim().startsWith('{') || !cleaned.trim().endsWith('}')) {
      throw const FormatException('Invalid JSON response from server');
    }

    return cleaned;
  }
  // Future< Map<String, double>> fetchExchangeRates() async {
  //   try {
  //     // Using ExchangeRate-API (free tier: 1500 requests/month)
  //     final response = await http.get(
  //       Uri.parse('https://api.exchangerate-api.com/v4/latest/SZL'),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final rates = data['rates'] as Map<String, dynamic>;
  //
  //       setState(() {
  //         // Keep current rates as previous before updating
  //         if (exchangeRates.isNotEmpty) {
  //           previousRates = Map.from(exchangeRates);
  //         }
  //
  //         exchangeRates = {
  //           'USD': rates['USD']?.toDouble() ?? 0.0,
  //           'EUR': rates['EUR']?.toDouble() ?? 0.0,
  //           'XAF': rates['XAF']?.toDouble() ?? 0.0, // CFA Franc
  //           'JPY': rates['JPY']?.toDouble() ?? 0.0,
  //           'GBP': rates['GBP']?.toDouble() ?? 0.0,
  //         };
  //
  //         isLoading = false;
  //
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching exchange rates: $e');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<TerminalSignOnResponse> signOn(
  {  required String username,
    required  String password,}
      ) async {
    try {
      String txnID = getTransactionID(parseDateTime2(DateTime.now()));
      String dateTime = getCurrentFormattedDateTime();
      TerminalSignOnRequest request = TerminalSignOnRequest(
        header:TerminalSignOnRequestHeader(
          countryCode: ConstantUtil.countryCode.toString(),
          deviceSerialNo: ConstantUtil.deviceSerialID,
          terminalType: ConstantUtil.terminalType,
          applicationName: AppStrings.appName,
          geoPositionalData: "-17.8275, 31.0120",
          acquiringNetworkID:ConstantUtil.acquiringNetworkID,
          businessID: '2025010001',
          deviceID: ConstantUtil.deviceID,
          outletID: 'S001',
        ),
        messageType: "0800",
        dateTime: dateTime,
        networkManagementCode: "004",
        mac: '', transactionID: txnID,
      );

      final response = await apiClient.post(
        '$BASE_URL/PayAPI/SignOn',
        headers: {
          //'Content-Type': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode("$username:$password"))}',
        },
        body: json.encode(request.toJson()),

      );
      debugPrint('Cleaned SignOn Response: ${response.body}');
      if (response.statusCode == 200) {
        return TerminalSignOnResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Invalid username or password');
      } else if (response.statusCode == 404) {
        throw Exception('Sign-On endpoint not found');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later');
      } else {
        throw Exception('Sign-On Failed: ${response.statusCode} - ${response.body}');
      }

    } on SocketException catch (e) {
      print('SocketException: ${e.message}');
      throw Exception('No internet connection. Please check your network');
    } on TimeoutException catch (e) {
      print('TimeoutException: $e');
      throw Exception('Connection timeout. Please try again');
    } on FormatException catch (e) {
      print('FormatException: ${e.message}');
      throw Exception('Invalid response format from server');
    } on HttpException catch (e) {
      print('HttpException: ${e.message}');
      throw Exception('Network error occurred');
    } catch (e) {
      print('Unexpected error in signOn: $e');
      throw Exception('Connection failed: ${e.toString()}');
    }
  }


  Future<TransactionQueryResponse> getTransactions(
      req.TransactionQueryRequest request,
      ) async {
    String? token = await _secureStorageService.getAuthToken();
    final isTokenValid = await _secureStorageService.isTokenValid();
    if (!isTokenValid) {
      final newToken = await refreshAccessToken();
      if (newToken == null) {
        throw Exception('Authentication failed: Unable to refresh token');
      }
      token = newToken; // Use the new token
    }

    if (token == null) throw Exception('Not signed in');
    final response = await apiClient.post(
      '$BASE_URL/PayAPI/Transaction/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(request.toJson()),
    );
     debugPrint('Transaction Request: ${request.toJson()}');
    debugPrint('Transaction Response: ${response.body}');
    if (response.statusCode == 200) {
      return TransactionQueryResponse.fromJson(json.decode(response.body));

    } else {
      //AppUtil.toastMessage(message: 'Error Getting Transactions:${response.statusCode}');
      throw Exception('Error Getting Transactions ${response.statusCode}');
    }
  }

  Future<PasswordChangeResponse> changePassword(
      PasswordChangeRequest request,
      ) async {
    final isTokenValid = await _secureStorageService.isTokenValid();
    if (!isTokenValid) {
      final isRefreshSuccessful = await refreshAccessToken();
      debugPrint('Getting New Token  ');
      if (isRefreshSuccessful == null) {
        debugPrint('Token Refresh Error');
        throw Exception('');
      }
    }
    String? authToken = await _secureStorageService.getAuthToken();

    final response = await apiClient.post(
      '$BASE_URL/PayAPI/SignOn/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(request.toJson()),
    );
    //debugPrint('Password Change Response: ${response.body}');
    if (response.statusCode == 200) {
      return PasswordChangeResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('');
    }
  }



  Future<TransactionQueryResponse> fetchTransactionsFromAPI(
      DateTime startDate,
      DateTime endDate,
      String dataManagementCode,
      ) async {
    final signOnData = await _secureStorageService.getSignOnFromStorage();
    String txnID = getTransactionID(parseDateTime2(DateTime.now()));
    String dateTime = getCurrentFormattedDateTime();
    debugPrint('TM: Fetching From API with DMC: $dataManagementCode');

    String formattedStart = startDate
        .toString()
        .replaceAll('-', '')
        .replaceAll(':', '')
        .replaceAll(' ', '')
        .substring(0, 14);
    String formattedEnd = endDate
        .toString()
        .replaceAll('-', '')
        .replaceAll(':', '')
        .replaceAll(' ', '')
        .substring(0, 14);
    // Create a DateTimeRange object using the original DateTime objects
    final req.QueryDateRange dateRange = req.QueryDateRange(
      startDate: formattedStart,
      endDate: formattedEnd,
    );

    req.TransactionQueryHeader header;
    header = req.TransactionQueryHeader(
      countryCode: signOnData!.header.countryCode,
      acquiringNetworkID: signOnData.header.acquiringNetworkID,
      acquiringNetworkName: signOnData.header.acquiringNetworkName,
      receivingNetworkID: '74801001',
      receivingNetworkName: "Rise App",
      businessID: signOnData.header.businessID,
      merchantName: signOnData.header.merchantName,
      merchantLocation: signOnData.header.merchantLocation,
      merchantCategoryCode: signOnData.header.merchantCategoryCode,
      outletID: signOnData.header.outletID!,
      outletName: 'Main Branch',
      // signOnData.header.outletName,
      deviceID: ConstantUtil.deviceID,
      deviceSerialNo: ConstantUtil.deviceSerialID,
      terminalType: ConstantUtil.terminalType,
      panEntryMode: '01',
      pinEntryCapability: '1',
      posConditionCode: '00',
      tellerID: signOnData.userInfo!.signOnID,
      tellerName: signOnData.userInfo!.fullName,
      geoPositionalData: '6.821000, 39.276505',
    );
    late req.TransactionQueryRequest transactionQueryRequest;

    transactionQueryRequest = req.TransactionQueryRequest(
      header: header,
      messageType: '0700',
      dataManagementCode: dataManagementCode,
      dateTime: dateTime,
      transactionID: txnID,
      query: dateRange,
      mac: '',
    );
    final transactionQueryResponse = await Repository().getTransactions(
      transactionQueryRequest,
    );

    return transactionQueryResponse;

  }




  //Use store credentials to sign user in and get new token
  Future<String?> refreshAccessToken() async {
    try {
      //003
      TerminalSignOnResponse? userSignOnResponse =
      await _secureStorageService.getSignOnFromStorage();
      final transactionStore = TransactionManager();
          transactionStore.terminalInfo.businessId;
      final currencyUser = transactionStore.terminalInfo.currentUser;

      //get Store Credentials

      if (userSignOnResponse == null || currencyUser == null) return null;
      final response = await signOn(
         username: currencyUser.signOnID,
         password: currencyUser.pin,

      );
      if (response.responseCode == '00') {
        //store token
        _secureStorageService.saveAuthToken(
            token: response.securityToken!,
            expiryTime:  DateTime.now().add(
                Duration(milliseconds: int.parse(response.tokenValidityPeriod!),
                ))
        );
        return response.securityToken;
      } else {
        throw Exception("authentication error");
      }
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }
}
