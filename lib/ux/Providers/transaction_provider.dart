import 'package:eswaini_destop_app/ux/models/shared/pos_user.dart';
import 'package:isar/isar.dart';

import '../../platform/utils/isar_manager.dart';
import '../models/shared/pos_transaction.dart';
import '../models/shared/transaction.dart';
import '../models/shared/transaction_row.dart';
import '../utils/sessionManager.dart';

class TransactionManager {
  // Singleton instance
  static final TransactionManager _instance = TransactionManager._internal();

  factory TransactionManager() => _instance;

  TransactionManager._internal();
  final isar = IsarService.db;
  final sessionManager = SessionManager();
  List<TxnRow> allTransactions = [];
  List<TxnRow> filtered = [];
  String? selectedUser;
  List<String> _users = [];

  bool isLoading = true;
  double get totalAmount => filtered.fold(0, (sum, t) => sum + t.amount);
  int get completedCount =>
      filtered.where((t) => t.status == PosTransactionStatus.completed).length;
  int get refundedCount =>
      filtered.where((t) => t.status == PosTransactionStatus.refunded).length;
  int get voidedCount =>
      filtered.where((t) => t.status == PosTransactionStatus.voided).length;
  int get cashCount =>
      filtered.where((t) => t.method == PaymentMethod.cash).length;
  int get mobileCount =>
      filtered.where((t) => t.method == PaymentMethod.mobileMoney).length;
  int get splitCount =>
      filtered.where((t) => t.method == PaymentMethod.split).length;
  int get cardCount =>
      filtered.where((t) => t.method == PaymentMethod.card).length;

  Future<void> loadTransactions({
    required Function() onFliter,
     bool isSubHeader =false,
    // required DateTime? startDate,
    // required DateTime? endDate,
  }) async {
    try {
      // load all transactions
      final txns = await isar.posTransactions.where().findAll();

      // load all users for name lookup
      final users = await isar.posUsers.where().findAll();
      final userMap = {for (final u in users) u.id: u.name};

      // build unique user name list for filter dropdown
      _users = users.map((u) => u.name).toList();

      // map to display rows
      allTransactions = txns.map((t) {
        return TxnRow(
          reference: t.transactionNumber,
          userName: userMap[t.processedByUserId] ?? 'Unknown',
          amount: t.totalAmount,
          method: t.paymentMethod,
          status: t.status,
          date: t.timestamp,
          orderNumber: t.orderNumber,
          saleOrderId: t.saleOrderId,
        );
      }).toList();

      // sort latest first
      allTransactions.sort((a, b) => b.date.compareTo(a.date));

      _users = _users.toSet().toList(); // remove duplicates

      if(!isSubHeader){
        onFliter();
      }else{
        applyFilters();
      }
    } catch (e) {
      print('❌ Load transactions error: $e');
    }
  }

  void applyFilters() {
    DateTime now = DateTime.now();

    DateTime startDate = DateTime(
      now.year,
      now.month,
      now.day,
      1,
    );

    DateTime endDate = now;

    filtered = allTransactions.where((t) {
      final matchesUser = t.userName == sessionManager.currentUser!.name;
      final matchesStart = !t.date.isBefore(startDate);

      final matchesEnd = !t.date.isAfter(
        DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          23,
          59,
          59,
        ),
      );

      return matchesUser && matchesStart && matchesEnd;
    }).toList();
  }
}
