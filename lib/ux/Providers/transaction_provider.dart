import '../../platform/utils/constant.dart';
import '../models/shared/device_data.dart';
import '../models/shared/terminal_cred.dart';
import '../models/shared/transaction.dart';
import '../models/terminal_sign_on_response.dart';
import '../utils/secure_storage.dart';

class TransactionManager {
  // Singleton instance
  static final TransactionManager _instance = TransactionManager._internal();

  factory TransactionManager() => _instance;

  TransactionManager._internal();

  TerminalCredentials terminalInfo = TerminalCredentials(
    currentUser: StoredUser(
      signOnID: '',
      fullName: '',
      pin: '',
      phoneNumber: '',
      emailAddress: '',
      accessLevel: '',
      accountStatus: '',
      dateCreation: '',
      dateLastSeen: '',
      outlets: '',
    ),
    businessId: '',
    outletID: '',
    outletName: '',
    merchantName: '',
    merchantLocation: '',
    requireLogin: false,
    activationDate: '',
    deviceData: DeviceData(deviceSerialNum: '', deviceModel: '', deviceId: ''),
    timestamp: '',
  );

  List<TransactionData> _transactions = [];

  TerminalSignOnResponse? sigOnInfo;

  Currency? activeCurrency;
  final List<Currency> currencies = ConstantUtil.eswatiniCurrencies;

  bool showSymbol = false;

  Future<TerminalCredentials> getTerminalData() async {
    return terminalInfo;
  }

  setSignOnData(TerminalSignOnResponse signOnData) async {
    sigOnInfo = signOnData;
  }

  Future<TerminalSignOnResponse> getSignOnData() async {
    return sigOnInfo!;
  }

  setTerminalData() async {
    terminalInfo = (await SecureStorageService.retrieveCredentials())!;
  }

  setCurrentUser({required StoredUser user}) async {
    terminalInfo = terminalInfo.copyWith(currentUser: user);
  }

  setCurrentPassword({required String psd}) async {
    final activeUser = terminalInfo.currentUser?.copyWith(pin: psd);
    setCurrentUser(user: activeUser!);
    await SecureStorageService.storeCredentials(terminalInfo);
  }

  Future<void> setActiveCurrency(Currency currency) async {
    activeCurrency = currency;
  }

  Future<void> setCurrencies(List<Currency?> currencyList) async {
    // currencies.clear();
    // currencies = eswatiniCurrencies();
    // final validCurrencies = currencyList.whereType<Currency>().toList();
    //
    // if (validCurrencies.isEmpty) return;
    //
    // if (validCurrencies.first.code == validCurrencies.last.code) {
    //   currencies.add(validCurrencies.first);
    // } else {
    //   currencies.addAll(validCurrencies);
    // }
  }

  Future<List<Currency>> getCurrencies() async {
    return currencies;
  }

  Future<Currency?> getCurrency() async {
    return activeCurrency;
  }

  // Basic CRUD operations

  List<TransactionData> getAllTransactions() {
    return _transactions.toList();
  }

  void addTransactionHistoryFromAPI(List<Map<String, dynamic>> transactions) {
    _transactions
      ..clear()
      ..addAll(transactions.map((e) => TransactionData.fromJson(e)));

    // Log summary of the batch operation
  }

  void addTransactionHistoryAfterTxnAPi(TransactionData transactions) {
    // Check if transaction is reversed
    if (transactions.reversed == "1") {
      // Try to find a matching transaction already in the list
      final index = _transactions.indexWhere(
            (t) => t.transactionId == transactions.transactionId,
      );

      if (index != -1) {
        // If found, update the reversed flag to "1"
        _transactions[index].reversed = "1";
      } else {
        // If not found, add it anyway
        _transactions.add(transactions);
      }
    } else {
      // Normal case — just add the new transaction
      _transactions.add(transactions);
    }
  }
}