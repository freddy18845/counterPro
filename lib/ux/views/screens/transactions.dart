import "dart:async";
import "package:eswaini_destop_app/ux/Providers/transaction_provider.dart";
import "package:eswaini_destop_app/ux/models/screens/home/flow_item.dart";
import "package:eswaini_destop_app/ux/models/shared/sale_order.dart";
import "package:eswaini_destop_app/ux/res/app_strings.dart";
import "package:eswaini_destop_app/ux/utils/sessionManager.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:isar/isar.dart";
import "../../../platform/utils/constant.dart";
import "../../../platform/utils/isar_manager.dart";
import "../../models/shared/pos_transaction.dart";
import "../../models/shared/transaction_row.dart";
import "../../res/app_colors.dart";
import "../../utils/export_service.dart";
import "../../utils/shared/app.dart";
import "../../utils/shared/screen.dart";
import "../components/screens/transactions/date_filter_btn.dart";
import "../components/screens/transactions/row_summary_card.dart";
import "../components/screens/transactions/table_row.dart";
import "../components/shared/card_widget.dart";
import "../components/shared/custom_icon_btn.dart";
import "../components/shared/inline_text.dart";
import "../components/shared/login_input.dart";
import "../components/shared/pagination.dart";
import "../components/shared/ui_template.dart";



class TransactionsScreen extends StatefulWidget {
  final HomeFlowItem selectedTransaction;

  const TransactionsScreen({
    super.key,
    required this.selectedTransaction,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final isar = IsarService.db;

  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedUser;
  List<String> _users = [];
  bool _isExporting = false;
  bool isLoading = true;
final sessionManager = SessionManager();
final transactionManager = TransactionManager();
  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalItems = 0;



  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    transactionManager.loadTransactions(onFliter:(){
      _applyFilters();
    });
    _searchController.addListener(_applyFilters);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    super.dispose();
  }



// add this method
  Future<void> _refresh() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    transactionManager.allTransactions.clear();
    transactionManager.loadTransactions(onFliter:(){
      _applyFilters();
    });
    setState(() => isLoading = false);
  }


  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      transactionManager.filtered =  transactionManager.allTransactions.where((t) {
        final matchesSearch =
            query.isEmpty ||
            t.reference.toLowerCase().contains(query) ||
            _methodLabel(t.method).toLowerCase().contains(query) ||
            t.amount.toStringAsFixed(2).contains(query);
        final matchesUser =sessionManager.isCashier?
        _selectedUser == null || t.userName == sessionManager.currentUser!.name.toString():
            _selectedUser == null || t.userName == _selectedUser;
        final matchesStart =
            _startDate == null || !t.date.isBefore(_startDate!);
        final matchesEnd =
            _endDate == null ||
            !t.date.isAfter(
              _endDate!.add(const Duration(hours: 23, minutes: 59)),
            );
        return matchesSearch && matchesUser && matchesStart && matchesEnd;
      }).toList();
      _totalItems =  transactionManager.filtered.length;
      _currentPage = 1;
    });
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedUser = null;
      _currentPage = 1;
    });
    _applyFilters();
  }

  String get _exportFileName {
    final now = DateTime.now();
    return 'transactions_${now.day}-${now.month}-${now.year}';
  }

  // ── Convert _TxnRow to ExportRow for ExportService ───────────
  List<TxnExportRow> get _exportRows =>  transactionManager.filtered
      .map(
        (t) => TxnExportRow(
          reference: t.reference,
          userName: t.userName,
          amount: t.amount,
          method: _methodLabel(t.method),
          status: _statusLabel(t.status),
          date: t.date,
        ),
      )
      .toList();
  Future<void> _updateTransaction({
    required int existingOrderId,
    required PosTransactionStatus newStatus,
  }) async {

    setState(() => isLoading = true);

    try {
      await isar.writeTxn(() async {
        /// ── FETCH ORDER ─────────────────────────
        final existingOrder =
        await isar.saleOrders.get(existingOrderId);

        if (existingOrder == null) {
          print('❌ No SaleOrder found for ID: $existingOrderId');
        } else {
          print('✅ Found SaleOrder: ${existingOrder.id}');

          existingOrder.status = SaleOrderStatus.cancelled; // ⚠️ change if needed
          existingOrder.completedAt = DateTime.now();

          print('📝 Updating SaleOrder: ${existingOrder.toString()}');

          await isar.saleOrders.put(existingOrder);
          print('✅ SaleOrder updated successfully');
        }

        /// ── FETCH TRANSACTION ───────────────────
        final existingTransaction = await isar.posTransactions
            .filter()
            .saleOrderIdEqualTo(existingOrderId)
            .findFirst();


          if (existingTransaction == null) {
            print('❌ No Transaction linked to Order ID: $existingOrderId');
          } else {
          print('✅ Found Transaction: ${existingTransaction.id}');

          existingTransaction.status = newStatus;
          existingTransaction.processedByUserId =
              SessionManager().userId ?? 0;
          existingTransaction.timestamp = DateTime.now();

          print(
              '📝 Updating Transaction: ${existingTransaction.toString()}');

          await isar.posTransactions.put(existingTransaction);

          print('✅ Transaction updated successfully');
        }
      });

      print('🎉 TRANSACTION COMPLETE');

      if (!mounted) return;

      AppUtil.toastMessage(
        message: '✅ Update Made Successfully',
        context: context,
        backgroundColor: Colors.green,
      );

      Navigator.pop(context, true);
    } catch (e, stack) {
      print('💥 ERROR in _updateTransaction');
      print('Error: $e');
      print('Stack: $stack');

      if (mounted) {
        AppUtil.toastMessage(
          message: '❌ Update failed: $e',
          context: context,
          backgroundColor: Colors.red,
        );
      }
    } finally {
      print('🛑 END _updateTransaction');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _exportExcel() async {
    setState(() => _isExporting = true);
    try {
      await ExportService.exportToExcel(
        context: context, // ← add this
        transactions: _exportRows,
        fileName: _exportFileName,
        tableName: 'transactions',

      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportWord() async {
    setState(() => _isExporting = true);
    try {
      await ExportService.exportToWord(
        context: context, // ← add this
        transactions: _exportRows,
        fileName: _exportFileName,
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  List<TxnRow> get _paged {
    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0,  transactionManager.filtered.length);
    if (start >=  transactionManager.filtered.length) return [];
    return  transactionManager.filtered.sublist(start, end);
  }

  int get _totalPages => (_totalItems / _pageSize).ceil().clamp(1, 999);

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _applyFilters();
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ScreenUtil.width >= 900;
    return BaseTemplate(
      isProcessing: isLoading,
      contentSection:  CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ConstantUtil.verticalSpacing / 2),
            InlineText(
              title: widget.selectedTransaction.text.toUpperCase(),
            ),
            SizedBox(height: ConstantUtil.verticalSpacing / 4),

            // ── Summary cards ─────────────────────────────
            SummaryCardRow(
              totalAmount:  transactionManager.totalAmount,
              completedCount:  transactionManager.completedCount,
              refundedCount:  transactionManager.refundedCount,
              voidedCount:  transactionManager.voidedCount,
            ),

            SizedBox(height: ConstantUtil.verticalSpacing / 2),

            // ── Filters row ───────────────────────────────
            Row(
              children: [
                SizedBox(
                  width: (ScreenUtil.width * 0.2).clamp(160, 280),
                  child: ConfigField(
                    controller: _searchController,
                    hintText: 'ID  or amount or Payment Type',
                    enabled: true,
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(width: ScreenUtil.width * 0.01),
                DateFilterBtn(
                  label: _startDate == null
                      ? 'Start Date'
                      : _formatDate(_startDate!),
                  onTap: () => _pickDate(isStart: true),
                  isSet: _startDate != null,
                ),
                SizedBox(width: ScreenUtil.width * 0.008),
                DateFilterBtn(
                  label: _endDate == null
                      ? 'End Date'
                      : _formatDate(_endDate!),
                  onTap: () => _pickDate(isStart: false),
                  isSet: _endDate != null,
                ),
                if(!sessionManager.isCashier)
                  SizedBox(width: ScreenUtil.width * 0.01),
                if(!sessionManager.isCashier)
                  SizedBox(
                    width: (ScreenUtil.width * 0.13).clamp(130, 200),
                    child: DropdownButtonFormField<String?>(
                      value: _selectedUser,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        isDense: true,
                      ),
                      hint: const Text(
                        'All Users',
                        style: TextStyle(fontSize: 12),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text(
                            'All Users',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        ..._users.map(
                              (u) => DropdownMenuItem(
                            value: u,
                            child: Text(
                              u,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => _selectedUser = val);
                        _applyFilters();
                      },
                    ),
                  ),

                const Spacer(),

                // ── Export buttons ────────────────────────
                if (_isExporting)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Row(
                    children: [
                      Text(
                        'Export To:   ',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Opacity(
                        opacity:  transactionManager.filtered.isEmpty ? 0.4 : 1.0,
                        child: CustomActionButton(
isDesktop: isDesktop,
                          onTap:  transactionManager.filtered.isEmpty ? () {} : _exportExcel,
                          label: 'Excel',
                          color: const Color(0xFF1D6F42),
                          icon: ExcelIconPainter(),
                        ),
                      ),

                      const SizedBox(width: 8),
                      Opacity(
                        opacity:  transactionManager.filtered.isEmpty ? 0.4 : 1.0,
                        child: CustomActionButton(
                          isDesktop: isDesktop,
                          onTap:  transactionManager.filtered.isEmpty ? () {} : _exportWord,
                          label: 'Word',
                          color: const Color(0xFF2B579A),
                          icon: WordIconPainter(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: isLoading ? null : _refresh,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                            width: 14,
                            height: 14,
                            child:    CupertinoActivityIndicator(radius: 18, color: Colors.green),
                          )
                              : Icon(
                            Icons.refresh_outlined,
                            size: 16,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),

                // clear filters
                if (_startDate != null ||
                    _endDate != null ||
                    _selectedUser != null ||
                    _searchController.text.isNotEmpty )
                  !sessionManager.isCashier? GestureDetector(
                    onTap: _clearFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.close, size: 14, color: Colors.red),
                          SizedBox(width: 4),
                          Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ):SizedBox(),
              ],
            ),

            SizedBox(height: ConstantUtil.verticalSpacing / 2),
            Divider(thickness: 1.5, color: AppColors.secondaryColor),
            SizedBox(height: ConstantUtil.verticalSpacing / 4),

            // ── Table ─────────────────────────────────────
            Expanded(
              child: isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    CupertinoActivityIndicator(radius: 18, color: Colors.green),
                    const SizedBox(height: 12),
                    const Text(AppStrings.fetchingTransactions,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13)),
                  ],
                ),
              )
                  : Column(
                children: [
                  TxnTableRow(
                    isHeader: true,
                    cells: const [
                      'Reference',
                      'User',
                      'Amount',
                      'Method',
                      'Status',
                      'Date',

                    ], onStatusChanged: (PosTransactionStatus status) {  },
                  ),
                  Expanded(
                    child: _paged.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No transactions found',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      itemCount: _paged.length,
                      itemBuilder: (context, index) {
                        final t = _paged[index];
                        return TxnTableRow(
                          isHeader: false,
                          isAlternate: index.isOdd,
                          cells: [
                            t.reference,
                            t.userName,
                            '${ConstantUtil.currencySymbol}${t.amount.toStringAsFixed(2)}',
                            _methodLabel(t.method),
                            _statusLabel(t.status),
                            _formatDate(t.date),
                          ],
                          status: t.status,
                          onStatusChanged: (PosTransactionStatus status)  {
                            _updateTransaction(existingOrderId: t.saleOrderId, newStatus: status);

                          },

                        ) .animate()
// 1. Wait slightly so it appears after the initial screen load
                            .fadeIn(delay: 300.ms, duration:(index
                            *600).ms)
// 2. Gently slide down from the top (using slideY with a negative begin)
                            .slideY(begin: -0.1, end: 0, curve: Curves.easeOutCubic)
// 3. Optional: add a slight blur-to-clear effect for a premium look
                            .blur(begin: const Offset(10, 10), end: Offset.zero);
                      },
                    ),
                  ),
                ],
              ),
            ),

            Divider(thickness: 1.5, color: AppColors.secondaryColor),
            Pagination(
              currentPage: _currentPage,
              totalPages: _totalPages,
              totalItems: _totalItems,
              pageSize: _pageSize,
              onPageChanged: (p) => setState(() => _currentPage = p),
            ),
            SizedBox(height: ConstantUtil.verticalSpacing / 2),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  String _methodLabel(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.mobileMoney:
        return 'Mobile';
      case PaymentMethod.split:
        return 'Split';
    }
  }

  String _statusLabel(PosTransactionStatus s) {
    switch (s) {
      case PosTransactionStatus.completed:
        return 'Completed';
      case PosTransactionStatus.refunded:
        return 'Refunded';
      case PosTransactionStatus.voided:
        return 'Voided';
    }
  }
}



