// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:rise_app/ux/Providers/transaction_provider.dart';
// import 'package:rise_app/ux/models/activation/terminal_activation_request.dart';
// import 'package:rise_app/ux/models/activation/terminal_activation_response.dart';
// import 'package:rise_app/ux/models/shared/password_change_request.dart';
// import 'package:rise_app/ux/models/shared/transaction_query_response.dart';
// import 'package:rise_app/ux/models/shared/transaction_request.dart';
// import 'package:rise_app/ux/models/shared/transaction_response.dart';
// import 'package:rise_app/ux/utils/secure_storage.dart';
// import 'package:rise_app/ux/utils/shared/app.dart';
// import '../../platform/utils/constant.dart';
// import '../../platform/utils/utils.dart';
// import '../../repo/activation_api.dart';
// import '../Providers/oderNum_provider.dart';
// import '../Providers/device_provider.dart';
// import '../models/activation/countryData.dart';
// import '../models/shared/activationRequest.dart' as actRequest;
// import '../models/shared/activationResponse.dart';
// import '../models/shared/device_data.dart';
// import '../models/shared/outletRequest.dart' as outletRquest;
// import '../models/shared/password_change_response.dart';
// import '../models/shared/queryOutletResponse.dart';
// import '../models/shared/signOnRequest.dart' as signOn;
// import '../models/shared/signOnResponse.dart' hide Header;
// import '../models/shared/terminal_cred.dart';
// import '../models/shared/trnsaction_quuery_request.dart' as queryRequest;
// import '../models/shared/user_request.dart' as userActivationRequest;
// import '../models/shared/user_response.dart' as userActivationResponse;
// import '../models/terminal_sign_on_request.dart';
// import '../models/terminal_sign_on_response.dart';
// import 'locator.dart';
//
//
// class ApiServices {
//   final SecureStorageService _secureStorageService =
//       locator<SecureStorageService>();
//   final deviceInfo = DeviceManager().getDeviceData();
//   final String terminalType = DeviceManager().getTerminalType();
//   final String APP_NAME = ConstantUtil.appName;
//
//
//   Future<TerminalActivationResponse?> activation({
//     required String networkManagementCode,
//   }) async {
//     String dateTime = getCurrentFormattedDateTime();
//
//     try{
//       UserSignOnResponse response= await activationSignIn(
//           psd: ConstantUtil.activatorPsd,
//           username:ConstantUtil. activatorUsername,);
//     if(response.responseCode!= "00"||
//         response.responseCode ==null){
//
//       AppUtil.toastMessage(message: "Country SignOn Activation failed: ${response.responseText}");
//       return null;
//     }else {
//
//       UserSignOnResponse response= await activationSignIn(
//         psd: ConstantUtil.activatorPsd,
//         username:ConstantUtil. activatorUsername,);
//
//
//       final TerminalCredentials activationData = TerminalCredentials(
//         outletName: 'Main Branch',
//         businessId: '2025010001',
//         outletID: "S001",
//         merchantName: "Test One",
//         merchantLocation: "Unknown City",
//         requireLogin: true,
//         activationDate: DateTime.now().toString(),
//         // currentUser: StoredUser(
//         //     signOnID: response.header!.tellerId!,
//         //     fullName: response.header!.tellerName!,
//         //     pin: activatorPsd,
//         //     phoneNumber: '',
//         //     emailAddress: '',
//         //     accessLevel: response.header!.tellerAccessLevel!,
//         //     accountStatus: response.header!.tellerAccountStatus!,
//         //     dateCreation: '',
//         //     dateLastSeen: '',
//         //     outlets: 'Main Branch'),
//         // activationUser: StoredUser(
//         //     signOnID: response.header!.tellerId!,
//         //     fullName: response.header!.tellerName!,
//         //     pin: '',
//         //     phoneNumber: '',
//         //     emailAddress: '',
//         //     accessLevel: response.header!.tellerAccessLevel!,
//         //     accountStatus: response.header!.tellerAccountStatus!,
//         //     dateCreation: '',
//         //     dateLastSeen: '',
//         //     outlets: 'Main Branch'
//         // ),
//         deviceData: DeviceData(
//           deviceSerialNum: deviceInfo.deviceSerialNum,
//           deviceModel: deviceInfo.deviceModel,
//           deviceId: deviceInfo.deviceId,
//         ),
//         timestamp: dateTime,
//
//       );
//       await SecureStorageService.storeCredentials(activationData);
//
//
//       String txnID = getTransactionID(parseDateTime2(DateTime.now()));
//       final CountryData countryData = CountryManager().getCountry();
//       String dateTimeNow = getCurrentFormattedDateTime();
//       TerminalActivationRequest request =
//       TerminalActivationRequest(
//         header: TerminalActivationRequestHeader(
//           countryCode: countryData.code.toString(),
//           acquiringNetworkID: "${countryData.code}001",
//           businessID: '2025010001',
//           outletID: 'S001',
//           deviceID: deviceInfo.deviceId,
//           deviceSerialNo: deviceInfo.deviceSerialNum,
//           terminalType: terminalType,
//           tellerID: 'Admin',
//           tellerName: 'Administrator',
//           applicationName: APP_NAME,
//           geoPositionalData: "-17.8275, 31.0120",
//           outletName: 'Main Branch',
//         ),
//         messageType: "0800",
//         dateTime: dateTimeNow,
//         networkManagementCode: networkManagementCode,
//         mac: '', transactionID: txnID,
//       ) ;
//
//       final TerminalActivationResponse result = await Repository()
//           .finalTerminalStep(request);
//
//       return result;
//     }}
//     catch (e) {
//       AppUtil.toastMessage(message: "Country Activation failed: $e");
//       return null;
//     }
//   }
//
//
//   Future<UserSignOnResponse> activationSignIn({
//     required String psd,
//     required String username,
//   }) async {
//     String txnID = getTransactionID(parseDateTime2(DateTime.now()));
//     String dateTime = getCurrentFormattedDateTime();
//     final newCountryData = CountryManager().getCountry();
//     signOn.UserSignOnRequest request = signOn.UserSignOnRequest(
//       header:signOn. UserSignOnRequestHeader(
//         countryCode: newCountryData.code.toString(),
//         deviceSerialNo: deviceInfo.deviceSerialNum,
//         terminalType: terminalType,
//         applicationName: APP_NAME,
//         geoPositionalData: "-17.8275, 31.0120",
//         acquiringNetworkID:" ${newCountryData.code}001",
//         businessID: '2025010001',
//         deviceID: deviceInfo.deviceId,
//       ),
//       messageType: "0800",
//       dateTime: dateTime,
//       networkManagementCode: "003",
//       mac: '', transactionID: txnID,
//     );
//
//     final UserSignOnResponse result = await Repository().activationSignOn(
//       request,
//       username,
//       psd,
//     );
//     if (result.responseCode == "00") {
//       // await _secureStorageService.saveSignOnResponseToStorage(
//       //   signOnResponse: result,
//       // );
//       await _secureStorageService.saveAuthToken(
//         token: result.securityToken!,
//         expiryTime: DateTime.parse(result.tokenValidityPeriod!),
//       );
//      //TransactionManager().setSignOnData(result);
//     }
//
//     return result;
//   }
//
//
//   Future<TerminalSignOnResponse> signIn({
//     required String psd,
//     required String username,
//   }) async {
//     String txnID = getTransactionID(parseDateTime2(DateTime.now()));
//     String dateTime = getCurrentFormattedDateTime();
//     final newCountryData = CountryManager().getCountry();
//
//     TerminalSignOnRequest request = TerminalSignOnRequest(
//       header:TerminalSignOnRequestHeader(
//         countryCode: newCountryData.code.toString(),
//         deviceSerialNo: deviceInfo.deviceSerialNum,
//         terminalType: terminalType,
//         applicationName: APP_NAME,
//         geoPositionalData: "-17.8275, 31.0120",
//         acquiringNetworkID:" ${newCountryData.code}001",
//         businessID: '2025010001',
//         deviceID: deviceInfo.deviceId,
//         outletID: 'S001',
//       ),
//       messageType: "0800",
//       dateTime: dateTime,
//       networkManagementCode: "004",
//       mac: '', transactionID: txnID,
//     );
//
//     final TerminalSignOnResponse result = await Repository().signOn(
//       request,
//       username,
//       psd,
//     );
//     if (result.responseCode == "00") {
//       await _secureStorageService.saveSignOnResponseToStorage(
//         signOnResponse: result,
//       );
//       await _secureStorageService.saveAuthToken(
//         token: result.securityToken!,
//         expiryTime: DateTime.parse(result.tokenValidityPeriod!),
//       );
//       TransactionManager().setSignOnData(result);
//     }
//
//     return result;
//   }
//
//   Future<OutletQueryResponse> getOutList({required String bID}) async {
//     // await Future.delayed(Duration(milliseconds: 500));
//     String txnID = getTransactionID(parseDateTime2(DateTime.now()));
//     String dateTime = getCurrentFormattedDateTime();
//     final CountryData countryData = CountryManager().getCountry();
//     outletRquest.OutletQueryRequest request = outletRquest.OutletQueryRequest(
//       header: outletRquest.Header(
//         countryCode: countryData.code.toString(),
//         acquiringNetworkId: "${countryData.code}001",
//         businessId: bID,
//         terminalType: terminalType,
//       ),
//       messageType: "0800",
//       dateTime: dateTime,
//       transactionId:txnID,
//       networkManagementCode: '203',
//       mac: '',
//     );
//
//     final OutletQueryResponse result = await Repository().getOutlet(
//       request,
//     );
//
//     return result;
//   }
//
//   Future<userActivationResponse.UserResponse> getUserList({
//
//     required bool isUserManagement,
//   }) async {
//     final CountryData countryData = CountryManager().getCountry();
//     String txnID = getTransactionID(parseDateTime2(DateTime.now()));
//     String dateTime = getCurrentFormattedDateTime();
//     userActivationRequest.UserRequest request =
//         userActivationRequest.UserRequest(
//           header: userActivationRequest.Header(
//             countryCode: countryData.code.toString(),
//             acquiringNetworkId: "${countryData.code}001",
//             businessId: '2025010001',
//             terminalType: terminalType,
//           ),
//           messageType: "0800",
//           dateTime: dateTime,
//           transactionId: txnID,
//           networkManagementCode:'202',
//           mac: '',
//         );
//
//     final userActivationResponse.UserResponse result =
//         await Repository().getUsers(request,isUserManagement);
//
//     return result;
//   }
//
//   Future<TransactionQueryResponse> fetchTransactionsFromAPI(
//     DateTime startDate,
//     DateTime endDate,
//     String dataManagementCode,
//   ) async {
//     final signOnData = await _secureStorageService.getSignOnFromStorage();
//     String txnID = getTransactionID(parseDateTime2(DateTime.now()));
//     String dateTime = getCurrentFormattedDateTime();
//     debugPrint('TM: Fetching From API with DMC: $dataManagementCode');
//
//       String formattedStart = startDate
//           .toString()
//           .replaceAll('-', '')
//           .replaceAll(':', '')
//           .replaceAll(' ', '')
//           .substring(0, 14);
//       String formattedEnd = endDate
//           .toString()
//           .replaceAll('-', '')
//           .replaceAll(':', '')
//           .replaceAll(' ', '')
//           .substring(0, 14);
//       // Create a DateTimeRange object using the original DateTime objects
//       final queryRequest.QueryDateRange dateRange = queryRequest.QueryDateRange(
//         startDate: formattedStart,
//         endDate: formattedEnd);
//
//     queryRequest.TransactionQueryHeader header;
//       header = queryRequest.TransactionQueryHeader(
//         countryCode: signOnData!.header.countryCode,
//         acquiringNetworkID: signOnData.header.acquiringNetworkID,
//         acquiringNetworkName: signOnData.header.acquiringNetworkName,
//         receivingNetworkID: '74801001',
//         receivingNetworkName: "Rise App",
//         businessID: signOnData.header.businessID,
//         merchantName: signOnData.header.merchantName,
//         merchantLocation: signOnData.header.merchantLocation,
//         merchantCategoryCode: signOnData.header.merchantCategoryCode,
//         outletID: signOnData.header.outletID!,
//         outletName: 'Main Branch',
//         // signOnData.header.outletName,
//         deviceID: deviceInfo.deviceId,
//         deviceSerialNo: deviceInfo.deviceSerialNum,
//         terminalType: terminalType,
//         panEntryMode: '01',
//         pinEntryCapability: '1',
//         posConditionCode: '00',
//         tellerID: signOnData.userInfo!.signOnID,
//         tellerName: signOnData.userInfo!.fullName,
//         geoPositionalData: '6.821000, 39.276505',
//       );
//       late queryRequest.TransactionQueryRequest transactionQueryRequest;
//
//       transactionQueryRequest = queryRequest.TransactionQueryRequest(
//         header: header,
//         messageType: '0700',
//         dataManagementCode: dataManagementCode,
//         dateTime: dateTime,
//         transactionID: txnID,
//         query: dateRange,
//         mac: '',
//       );
//       final transactionQueryResponse = await Repository().getTransactions(
//         transactionQueryRequest,
//       );
//
//       return transactionQueryResponse;
//
//   }
//
//   Future<TransactionResponse> transaction({
//     required String receivingNetworkId,
//     required String receivingNetworkName,
//     required String panEntryMode,
//     required String posConditionCode,
//     required String messageType,
//     required String transactionType,
//     required String tenderType,
//     required String forcePost,
//     required String pan,
//     required String transactionAmount,
//     required String cashBackAmount,
//     required String iccData,
//     required String panSequenceNo,
//     required String track2Data,
//     required String pin1Data,
//     required Currency currentCurrency,
//     required String authorizerId,
//     required String authorizerName,
//     required String authorizationCode,
//     required String authorizationRef,
//     required String transactionId
//   })async{
//     final signOnData = await _secureStorageService.getSignOnFromStorage();
//
//
//
//     String txnID = getTransactionID(parseDateTime2(DateTime.now()));
//     String dateTime = getCurrentFormattedDateTime();
//     TransactionRequest request = TransactionRequest(
//         header: TransactionRequestHeader(
//             countryCode: signOnData!.header.countryCode,
//             acquiringNetworkId: signOnData.header.acquiringNetworkID,
//             acquiringNetworkName: signOnData.header.acquiringNetworkName,
//             receivingNetworkId: receivingNetworkId.isEmpty?
//             signOnData.header.acquiringNetworkID:receivingNetworkId,
//             receivingNetworkName: receivingNetworkName,
//             businessId: signOnData.header.businessID,
//             merchantName: signOnData.header.merchantName,
//             merchantLocation: signOnData.header.merchantLocation,
//             merchantCategoryCode: signOnData.header.merchantCategoryCode,
//             outletID: signOnData.header.outletID!,
//             outletName: signOnData.header.outletName!,
//             deviceSerialNo: deviceInfo.deviceSerialNum,
//           deviceId: deviceInfo.deviceId,
//             terminalType: terminalType,
//             panEntryMode: panEntryMode,
//             pinEntryCapability: '1',
//             posConditionCode: posConditionCode,
//             tellerId: signOnData.userInfo!.signOnID,
//             tellerName: signOnData.header.merchantName,
//             geoPositionalData: "-6.821000, 39.276505",
//             authorizerID:authorizerId,
//           authorizerName: authorizerName
//         ),
//         messageType: messageType,
//         transactionType: transactionType,
//         dateTime: dateTime,
//         merchantId:currentCurrency.merchantID! ,
//         terminalId: currentCurrency.terminalID!,
//         transactionId:transactionId.isEmpty? txnID :transactionId,
//         forcePost: forcePost,
//         tenderType: tenderType,
//         pan: pan,
//         iccData: iccData,
//         panSequenceNo: panSequenceNo,
//         pin1Data: pin1Data,
//         track2Data: track2Data,
//         currency: currentCurrency.code,
//         transactionAmount: transactionAmount,
//         cashBackAmount: cashBackAmount,
//         exchangeRate: '1',
//         referenceInfo: '',
//         narration: '',
//         echoData: '',
//         mac: '',
//
//         authorizationCode: authorizationCode,
//         authorizationReference: authorizationRef,
//         customerInfo: CustomerInfo(
//             customerName: 'Mr. John Buyer',
//             customerPhone: '233754328307',
//             customerEmail: 'customer@email.com'),
//
//         customData: '');
//     TransactionResponse  result= await Repository().transact(request);
//
//
//     return result;
//   }
//
//   Future<PasswordChangeResponse> changePassword({
//     required bool isChange,
//   required String newPassword,
//   required String oldPassword,
//
// }) async {
// final signOnData = await _secureStorageService.getSignOnFromStorage();
//
// String txnID = getTransactionID(parseDateTime2(DateTime.now()));
// final header = PasswordChangeRequestHeader(
// countryCode: signOnData!.header.countryCode,
// acquiringNetworkID: signOnData.header.acquiringNetworkID,
// acquiringNetworkName: signOnData.header.acquiringNetworkName,
// businessID: signOnData.header.businessID,
// deviceID: deviceInfo.deviceId,
// deviceSerialNo: deviceInfo.deviceSerialNum,
// terminalType: '01',
// tellerID: signOnData.userInfo?.signOnID??"N/A",
// tellerName: signOnData.userInfo!.fullName,
// geoPositionalData: " -6.821000, 39.276505",
// );
//
//
// //Build userInfo on changing password or resetting password
// final userInfo = PasswordChangeUserInfo(
// signOnID: signOnData.userInfo!.signOnID??"N/A" ,
// fullName: isChange ? signOnData.userInfo!.fullName : null,
// password:isChange? oldPassword :newPassword ,
// newPassword: isChange ? newPassword : null,
// );
// final changePasswordRequest = PasswordChangeRequest(
// header: header,
// messageType: '0300',
// dateTime: getCurrentFormattedDateTime(),
// transactionID: txnID,
// userManagementCode: isChange ? '004' : '003',
// userInfo: userInfo,
// mac: '',
// );
//
// final response = await Repository().changePassword(changePasswordRequest);
// return response;
// }
//
//   // Future<UserManagementResponse> addNewUser({
//   //   required NewUserInfo newUserInfo,
//   // }) async {
//   //   final signOnData = await _secureStorageService.getSignOnFromStorage();
//   //
//   //   String txnID = getTransactionID(parseDateTime2(DateTime.now()));
//   //   String dateTime = getCurrentFormattedDateTime();
//   //   final userInfo = NewUserInfo(
//   //     signOnID: newUserInfo.signOnID,
//   //     fullName: newUserInfo.fullName,
//   //     phoneNumber: newUserInfo.phoneNumber,
//   //     emailAddress: newUserInfo.emailAddress ,
//   //     outlets: newUserInfo.outlets,
//   //     accessLevel: newUserInfo.accessLevel,
//   //     status: 'N',
//   //     password: newUserInfo.password,
//   //   );
//   //
//   //   UserQueryRequest userQueryRequest = UserQueryRequest(
//   //     header: UserQueryRequestHeader(
//   //       countryCode: signOnData!.header!.countryCode!,
//   //       acquiringNetworkID: signOnData.header!.acquiringNetworkId!,
//   //       businessID: signOnData.header!.businessId!,
//   //       terminalType: terminalType,
//   //       acquiringNetworkName:signOnData.header!.acquiringNetworkName!,
//   //       deviceID: deviceInfo.deviceId,
//   //       deviceSerialNo: deviceInfo.deviceSerialNum,
//   //       tellerID: signOnData.header!.tellerId!,
//   //       tellerName:signOnData.header!.tellerName!,
//   //       geoPositionalData: '-6.821000, 39.276505',
//   //     ),
//   //     messageType: "0300",
//   //     userManagementCode: '001',
//   //     dateTime: dateTime,
//   //     userInfo: userInfo,
//   //     transactionID: txnID,
//   //     mac: '',
//   //   );
//   //
//   //  final  result = await Repository().createAndEditUser(request: userQueryRequest);
//   //
//   //
//   //   return result;
//   // }
//
//
//   // Future<UserManagementResponse> updateUser({
//   //   required NewUserInfo newUserInfo,
//   // }) async {
//   //   final signOnData = await _secureStorageService.getSignOnFromStorage();
//   //
//   //   String txnID = getTransactionID(parseDateTime2(DateTime.now()));
//   //   String dateTime = getCurrentFormattedDateTime();
//   //   final UserQueryRequestHeader header =  UserQueryRequestHeader(
//   //     countryCode: signOnData!.header!.countryCode!,
//   //     acquiringNetworkID: signOnData.header!.acquiringNetworkId!,
//   //     businessID: signOnData.header!.businessId!,
//   //     terminalType: terminalType,
//   //     acquiringNetworkName:signOnData.header!.acquiringNetworkName!,
//   //     deviceID: deviceInfo.deviceId,
//   //     deviceSerialNo: deviceInfo.deviceSerialNum,
//   //     tellerID: signOnData.header!.tellerId!,
//   //     tellerName:signOnData.header!.tellerName!,
//   //     geoPositionalData: '-6.821000, 39.276505',
//   //   );
//   //
//   //   final UserQueryRequest request = UserQueryRequest(
//   //     header: header,
//   //     messageType: '0300',
//   //     dateTime: dateTime,
//   //     transactionID: txnID,
//   //     userManagementCode: '002',
//   //     userInfo: NewUserInfo(
//   //       signOnID: newUserInfo.signOnID,
//   //       fullName: newUserInfo.fullName,
//   //       phoneNumber: newUserInfo.phoneNumber ?? '',
//   //       emailAddress: newUserInfo.emailAddress ?? '',
//   //       outlets: newUserInfo.outlets,
//   //       accessLevel: newUserInfo.accessLevel,
//   //       status: newUserInfo.status,
//   //     ),
//   //     mac: '',
//   //   );
//   //
//   //   final  result = await SigOnRepository().createAndEditUser(request: request);
//   //
//   //
//   //   return result;
//   // }
// }
