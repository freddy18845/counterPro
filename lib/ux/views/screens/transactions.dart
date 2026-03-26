import "dart:async";
import "package:eswaini_destop_app/ux/models/screens/home/flow_item.dart";
import "package:eswaini_destop_app/ux/models/shared/pos_user.dart";
import "package:eswaini_destop_app/ux/res/app_strings.dart";
import "package:eswaini_destop_app/ux/utils/sessionManager.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:isar/isar.dart";
import "../../../platform/utils/constant.dart";
import "../../../platform/utils/isar_manager.dart";
import "../../blocs/screens/withdrawal/bloc.dart";
import "../../enums/screens/payment/flow_step.dart";
import "../../models/shared/pos_transaction.dart";
import "../../res/app_colors.dart";
import "../../utils/export_service.dart";
import "../../utils/shared/screen.dart";
import "../components/shared/btn.dart";
import "../components/shared/card_widget.dart";
import "../components/shared/custom_icon_btn.dart";
import "../components/shared/inline_text.dart";
import "../components/shared/login_input.dart";
import "../components/shared/pagination.dart";
import "../components/shared/ui_template.dart";

// ── Display model ─────────────────────────────────────────────
class _TxnRow {
  final String reference;
  final String userName;
  final double amount;
  final PaymentMethod method;
  final PosTransactionStatus status;
  final DateTime date;

  _TxnRow({
    required this.reference,
    required this.userName,
    required this.amount,
    required this.method,
    required this.status,
    required this.date,
  });
}

class TransactionsScreen extends StatefulWidget {
  final HomeFlowItem selectedTransaction;
  final StreamController<Map> refreshController;

  const TransactionsScreen({
    super.key,
    required this.selectedTransaction,
    required this.refreshController,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late WithdrawalBloc withdrawalBloc;
  final TextEditingController _searchController = TextEditingController();
  final isar = IsarService.db;

  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedUser;
  List<String> _users = [];
  bool _isExporting = false;
  bool isLoading = true;
final sessionManager = SessionManager();
  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalItems = 0;

  List<_TxnRow> _allTransactions = [];
  List<_TxnRow> _filtered = [];

  @override
  void initState() {
    super.initState();
    withdrawalBloc = context.read<WithdrawalBloc>();
    withdrawalBloc.init(
      context: context,
      data: widget.selectedTransaction,
      refreshController: widget.refreshController,
    );
    _loadTransactions();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    try {
      withdrawalBloc.dispose();
    } catch (_) {}
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    super.dispose();
  }



// add this method
  Future<void> _refresh() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    _allTransactions.clear();
    _loadTransactions();
    setState(() => isLoading = false);
  }
  Future<void> _loadTransactions() async {
    setState(() => isLoading = true);

    try {
      // load all transactions
      final txns = await isar.posTransactions.where().findAll();

      // load all users for name lookup
      final users = await isar.posUsers.where().findAll();
      final userMap = {for (final u in users) u.id: u.name};

      // build unique user name list for filter dropdown
      _users = users.map((u) => u.name).toList();

      // map to display rows
      _allTransactions = txns.map((t) {
        return _TxnRow(
          reference: t.transactionNumber,
          userName: userMap[t.processedByUserId] ?? 'Unknown',
          amount: t.totalAmount,
          method: t.paymentMethod,
          status: t.status,
          date: t.timestamp,
        );
      }).toList();

      // sort latest first
      _allTransactions.sort((a, b) => b.date.compareTo(a.date));

      _users = _users.toSet().toList(); // remove duplicates
      _applyFilters();
    } catch (e) {
      print('❌ Load transactions error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = _allTransactions.where((t) {
        final matchesSearch =
            query.isEmpty ||
            t.reference.toLowerCase().contains(query) ||
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
      _totalItems = _filtered.length;
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
  List<TxnExportRow> get _exportRows => _filtered
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

  Future<void> _exportExcel() async {
    setState(() => _isExporting = true);
    try {
      await ExportService.exportToExcel(
        context: context, // ← add this
        transactions: _exportRows,
        fileName: _exportFileName,
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

  List<_TxnRow> get _paged {
    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filtered.length);
    if (start >= _filtered.length) return [];
    return _filtered.sublist(start, end);
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

  double get _totalAmount => _filtered.fold(0, (sum, t) => sum + t.amount);
  int get _completedCount =>
      _filtered.where((t) => t.status == PosTransactionStatus.completed).length;
  int get _refundedCount =>
      _filtered.where((t) => t.status == PosTransactionStatus.refunded).length;
  int get _voidedCount =>
      _filtered.where((t) => t.status == PosTransactionStatus.voided).length;

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      isProcessing: isLoading,
      contentSection: BlocBuilder<WithdrawalBloc, WithdrawalState>(
        builder: (context, WithdrawalState state) {
          if (state is! WithdrawalEnterAmountState) return const SizedBox();
          withdrawalBloc.activeStep = GeneralTransactionFlowStep.enterAmount;

          return CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ConstantUtil.verticalSpacing / 2),
                InlineText(
                  title: widget.selectedTransaction.text.toUpperCase(),
                ),
                SizedBox(height: ConstantUtil.verticalSpacing / 4),

                // ── Summary cards ─────────────────────────────
                Row(
                  children: [
                    _SummaryCard(
                      label: 'Total Amount',
                      value:
                          '${ConstantUtil.currencySymbol} ${_totalAmount.toStringAsFixed(2)}',
                      color: AppColors.primaryColor,
                      icon: Icons.attach_money,
                    ),
                    SizedBox(width: ScreenUtil.width * 0.01),
                    _SummaryCard(
                      label: 'Completed',
                      value: '$_completedCount',
                      color: Colors.green,
                      icon: Icons.check_circle_outline,
                    ),
                    SizedBox(width: ScreenUtil.width * 0.01),
                    _SummaryCard(
                      label: 'Refunded',
                      value: '$_refundedCount',
                      color: Colors.orange,
                      icon: Icons.replay,
                    ),
                    SizedBox(width: ScreenUtil.width * 0.01),
                    _SummaryCard(
                      label: 'Voided',
                      value: '$_voidedCount',
                      color: Colors.red,
                      icon: Icons.cancel_outlined,
                    ),
                  ],
                ),

                SizedBox(height: ConstantUtil.verticalSpacing / 2),

                // ── Filters row ───────────────────────────────
                Row(
                  children: [
                    SizedBox(
                      width: (ScreenUtil.width * 0.2).clamp(160, 280),
                      child: ConfigField(
                        controller: _searchController,
                        hintText: 'Reference or amount...',
                        enabled: true,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    SizedBox(width: ScreenUtil.width * 0.01),
                    _DateFilterBtn(
                      label: _startDate == null
                          ? 'Start Date'
                          : _formatDate(_startDate!),
                      onTap: () => _pickDate(isStart: true),
                      isSet: _startDate != null,
                    ),
                    SizedBox(width: ScreenUtil.width * 0.008),
                    _DateFilterBtn(
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
                            opacity: _filtered.isEmpty ? 0.4 : 1.0,
                            child: CustomActionButton(
                              onTap: _filtered.isEmpty ? () {} : _exportExcel,
                              label: 'Excel',
                              color: const Color(0xFF1D6F42),
                              icon: ExcelIconPainter(),
                            ),
                          ),

                          const SizedBox(width: 8),
                          Opacity(
                            opacity: _filtered.isEmpty ? 0.4 : 1.0,
                            child: CustomActionButton(
                              onTap: _filtered.isEmpty ? () {} : _exportWord,
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryColor,
                                ),
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
                      _TxnTableRow(
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
                                  return _TxnTableRow(
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
                                    onStatusChanged: (PosTransactionStatus status) {  },

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
          );
        },
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

// ── Summary card ──────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Date filter button ────────────────────────────────────────
class _DateFilterBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSet;

  const _DateFilterBtn({
    required this.label,
    required this.onTap,
    required this.isSet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSet
              ? AppColors.primaryColor.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSet
                ? AppColors.primaryColor.withOpacity(0.5)
                : Colors.grey.withOpacity(0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: isSet ? AppColors.primaryColor : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSet ? AppColors.primaryColor : Colors.grey,
                fontWeight: isSet ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Table row ─────────────────────────────────────────────────
class _TxnTableRow extends StatelessWidget {
  final List<String> cells;
  final bool isHeader;
  final bool isAlternate;
  final PosTransactionStatus? status;
  final Function(PosTransactionStatus status)? onStatusChanged;
  const _TxnTableRow({
    required this.cells,
    this.isHeader = false,
    this.isAlternate = false,
    this.status,
     this.onStatusChanged,
  });

  Color _statusColor(PosTransactionStatus s) {
    switch (s) {
      case PosTransactionStatus.completed:
        return Colors.green;
      case PosTransactionStatus.refunded:
        return Colors.orange;
      case PosTransactionStatus.voided:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isHeader
            ? AppColors.primaryColor.withOpacity(0.12)
            : isAlternate
            ? Colors.grey.withOpacity(0.04)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.15)),
        ),
      ),
      child: Row(
        children: cells.asMap().entries.map((entry) {
          final i = entry.key;
          final cell = entry.value;
          final isStatusCol = !isHeader && i == 4 && status != null;

          return Expanded(
            child: isStatusCol
                ? Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: _statusColor(status ?? PosTransactionStatus.completed)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _statusColor(status ?? PosTransactionStatus.completed)
                        .withOpacity(0.4),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<PosTransactionStatus>(
                    value: status,
                    isDense: true,
                    icon: const Icon(Icons.arrow_drop_down, size: 16),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color:
                      _statusColor(status ?? PosTransactionStatus.completed),
                    ),
                    items: PosTransactionStatus.values.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(s.name, style: TextStyle( color:
                        _statusColor(s)),),
                      );
                    }).toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) {
                       onStatusChanged!(newStatus); // 👈 YOU must handle this
                      }
                    },
                  ),
                ),
              ),
            )
            // Align(
            //         alignment: Alignment.centerLeft,
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(
            //             horizontal: 8,
            //             vertical: 3,
            //           ),
            //           decoration: BoxDecoration(
            //             color: _statusColor(status!).withOpacity(0.1),
            //             borderRadius: BorderRadius.circular(20),
            //             border: Border.all(
            //               color: _statusColor(status!).withOpacity(0.4),
            //             ),
            //           ),
            //           child: Text(
            //             cell,
            //             style: TextStyle(
            //               fontSize: 11,
            //               fontWeight: FontWeight.w600,
            //               color: _statusColor(status!),
            //             ),
            //           ),
            //         ),
            //       )
                : Text(
                    cell,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isHeader
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isHeader ? AppColors.primaryColor : Colors.black87,
                    ),
                  ),
          );
        }).toList(),
      ),
    );
  }
}
