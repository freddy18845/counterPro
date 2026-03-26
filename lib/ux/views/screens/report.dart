import "dart:async";
import "package:eswaini_destop_app/ux/models/screens/home/flow_item.dart";
import "package:eswaini_destop_app/ux/models/shared/inventory.dart";
import "package:eswaini_destop_app/ux/models/shared/pos_transaction.dart";
import "package:eswaini_destop_app/ux/models/shared/product.dart";
import "package:eswaini_destop_app/ux/models/shared/sale_order.dart";
import "package:eswaini_destop_app/ux/res/app_strings.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:isar/isar.dart";
import "../../../platform/utils/constant.dart";
import "../../../platform/utils/isar_manager.dart";
import "../../blocs/screens/withdrawal/bloc.dart";
import "../../enums/screens/payment/flow_step.dart";
import "../../res/app_colors.dart";
import "../../utils/export_service.dart";
import "../../utils/shared/screen.dart";
import "../components/screens/Report/bar_chat.dart";
import "../components/screens/Report/date_btn.dart";
import "../components/screens/Report/donut_chart.dart";
import "../components/screens/Report/payment_breakdown.dart";
import "../components/screens/Report/progress_bar.dart";
import "../components/screens/Report/start_row.dart";
import "../components/shared/card_widget.dart";
import "../components/shared/custom_icon_btn.dart";
import "../components/shared/inline_text.dart";
import "../components/shared/ui_template.dart";

enum ReportPeriod { today, thisWeek, thisMonth, custom }

class SalesSummary {
  final String label;
  final double amount;
  final int count;
  final Color color;
  final IconData icon;

  SalesSummary({
    required this.label,
    required this.amount,
    required this.count,
    required this.color,
    required this.icon,
  });
}

class TopProduct {
  final String name;
  final String sku;
  final int qtySold;
  final double revenue;

  TopProduct({
    required this.name,
    required this.sku,
    required this.qtySold,
    required this.revenue,
  });
}

class ReportScreen extends StatefulWidget {
  final HomeFlowItem selectedTransaction;
  final StreamController<Map> refreshController;

  const ReportScreen({
    super.key,
    required this.selectedTransaction,
    required this.refreshController,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late WithdrawalBloc withdrawalBloc;
  final isar = IsarService.db;

  ReportPeriod _period = ReportPeriod.thisMonth;
  DateTime? _customStart;
  DateTime? _customEnd;
  bool _isExporting = false;
  bool _isLoading = false;

  List<SalesSummary> _summaries = [];
  List<TopProduct> _topProducts = [];
  List<DailySale> _dailySales = [];
  List<PaymentBreakdown> _paymentBreakdown = [];

  double _totalRevenue = 0;
  double _totalCost = 0;
  double _grossProfit = 0;
  int _totalOrders = 0;
  int _totalItemsSold = 0;

  @override
  void initState() {
    super.initState();
    withdrawalBloc = context.read<WithdrawalBloc>();
    withdrawalBloc.init(
      context: context,
      data: widget.selectedTransaction,
      refreshController: widget.refreshController,
    );
    _loadData();
  }

  @override
  void dispose() {
    try {
      withdrawalBloc.dispose();
    } catch (_) {}
    super.dispose();
  }

  // ── Date range for selected period ───────────────────────────
  DateTime get _startDate {
    final now = DateTime.now();
    if (_customStart != null && _period == ReportPeriod.custom) {
      return _customStart!;
    }
    switch (_period) {
      case ReportPeriod.today:
        return DateTime(now.year, now.month, now.day);
      case ReportPeriod.thisWeek:
        return now.subtract(Duration(days: now.weekday - 1));
      case ReportPeriod.thisMonth:
        return DateTime(now.year, now.month, 1);
      case ReportPeriod.custom:
        return DateTime(2020);
    }
  }

  DateTime get _endDate {
    if (_customEnd != null && _period == ReportPeriod.custom) {
      return _customEnd!
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));
    }
    return DateTime.now();
  }

  // ── Load real data from Isar ──────────────────────────────────
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      // fetch completed orders in date range
      final allOrders = await isar.saleOrders
          .where()
          .filter()
          .statusEqualTo(SaleOrderStatus.completed)
          .findAll();

      final orders = allOrders.where((o) {
        final completedAt = o.completedAt ?? o.createdAt;
        return !completedAt.isBefore(_startDate) &&
            !completedAt.isAfter(_endDate);
      }).toList();

      // fetch transactions in date range
      final allTxns = await isar.posTransactions.where().findAll();
      final txns = allTxns.where((t) {
        return !t.timestamp.isBefore(_startDate) &&
            !t.timestamp.isAfter(_endDate);
      }).toList();

      // ── Compute totals ──────────────────────────────────────
      _totalRevenue =
          orders.fold(0, (s, o) => s + o.totalAmount);
      _totalCost =
          orders.fold(0, (s, o) {
            final cost = o.items.fold(
                0.0, (sum, item) => sum + (item.costPrice * item.quantity));
            return s + cost;
          });
      _grossProfit = _totalRevenue - _totalCost;
      _totalOrders = orders.length;
      _totalItemsSold = orders.fold(
          0, (s, o) => s + o.items.fold(0, (sum, i) => sum + i.quantity));

      // ── Daily sales (last 7 days) ───────────────────────────
      final now = DateTime.now();
      _dailySales = List.generate(7, (i) {
        final date = now.subtract(Duration(days: 6 - i));
        final dayStart = DateTime(date.year, date.month, date.day);
        final dayEnd = dayStart
            .add(const Duration(hours: 23, minutes: 59, seconds: 59));

        final dayOrders = orders.where((o) {
          final d = o.completedAt ?? o.createdAt;
          return !d.isBefore(dayStart) && !d.isAfter(dayEnd);
        }).toList();

        final amount =
        dayOrders.fold(0.0, (s, o) => s + o.totalAmount);
        final count = dayOrders.length;
        return DailySale(date: date, amount: amount, count: count);
      });

      // ── Top products by revenue ─────────────────────────────
      final Map<String, _ProductAgg> productMap = {};
      for (final order in orders) {
        for (final item in order.items) {
          final key = item.productSku;
          if (productMap.containsKey(key)) {
            productMap[key]!.qtySold += item.quantity;
            productMap[key]!.revenue += item.totalPrice;
          } else {
            productMap[key] = _ProductAgg(
              name: item.productName,
              sku: item.productSku,
              qtySold: item.quantity,
              revenue: item.totalPrice,
            );
          }
        }
      }

      _topProducts = productMap.values
          .map((a) => TopProduct(
        name: a.name,
        sku: a.sku,
        qtySold: a.qtySold,
        revenue: a.revenue,
      ))
          .toList()
        ..sort((a, b) => b.revenue.compareTo(a.revenue));

      // take top 6
      if (_topProducts.length > 6) {
        _topProducts = _topProducts.sublist(0, 6);
      }

      // ── Payment breakdown ───────────────────────────────────
      final Map<PaymentMethod, double> methodAmounts = {};
      final Map<PaymentMethod, int> methodCounts = {};

      for (final txn in txns) {
        methodAmounts[txn.paymentMethod] =
            (methodAmounts[txn.paymentMethod] ?? 0) + txn.totalAmount;
        methodCounts[txn.paymentMethod] =
            (methodCounts[txn.paymentMethod] ?? 0) + 1;
      }

      final methodColors = {
        PaymentMethod.cash: Colors.green,
        PaymentMethod.card: Colors.blue,
        PaymentMethod.mobileMoney: Colors.orange,
        PaymentMethod.split: Colors.purple,
      };

      final methodLabels = {
        PaymentMethod.cash: 'Cash',
        PaymentMethod.card: 'Card',
        PaymentMethod.mobileMoney: 'Mobile Money',
        PaymentMethod.split: 'Split',
      };

      _paymentBreakdown = PaymentMethod.values
          .where((m) => (methodAmounts[m] ?? 0) > 0)
          .map((m) => PaymentBreakdown(
        method: methodLabels[m]!,
        amount: methodAmounts[m] ?? 0,
        count: methodCounts[m] ?? 0,
        color: methodColors[m]!,
      ))
          .toList();

      // ── Summaries ───────────────────────────────────────────
      _summaries = [
        SalesSummary(
          label: 'Total Revenue',
          amount: _totalRevenue,
          count: _totalOrders,
          color: AppColors.primaryColor,
          icon: Icons.attach_money,
        ),
        SalesSummary(
          label: 'Gross Profit',
          amount: _grossProfit,
          count: _totalOrders,
          color: Colors.green,
          icon: Icons.trending_up,
        ),
        SalesSummary(
          label: 'Total Cost',
          amount: _totalCost,
          count: _totalItemsSold,
          color: Colors.orange,
          icon: Icons.shopping_bag_outlined,
        ),
        SalesSummary(
          label: 'Avg Order Value',
          amount: _totalOrders > 0 ? _totalRevenue / _totalOrders : 0,
          count: _totalOrders,
          color: Colors.purple,
          icon: Icons.receipt_outlined,
        ),
      ];
    } catch (e) {
      print('❌ ReportScreen load error: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _pickCustomDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
          ColorScheme.light(primary: AppColors.primaryColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _customStart = picked;
        } else {
          _customEnd = picked;
        }
      });
      _loadData();
    }
  }

  String get _exportFileName {
    final now = DateTime.now();
    return 'report_${now.day}-${now.month}-${now.year}';
  }

  List<TxnExportRow> get _exportRows => _dailySales
      .map((d) => TxnExportRow(
    reference: 'DAY-${_formatDate(d.date)}',
    userName: 'All Users',
    amount: d.amount,
    method: 'All',
    status: 'Completed',
    date: d.date,
  ))
      .toList();

  Future<void> _exportExcel() async {
    setState(() => _isExporting = true);
    try {
      await ExportService.exportToExcel(
        context: context,
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
        context: context,
        transactions: _exportRows,
        fileName: _exportFileName,
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      isProcessing: _isLoading,
      contentSection: BlocBuilder<WithdrawalBloc, WithdrawalState>(
        builder: (context, WithdrawalState state) {
          if (state is! WithdrawalEnterAmountState) {
            return const SizedBox();
          }
          withdrawalBloc.activeStep =
              GeneralTransactionFlowStep.enterAmount;

          return CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ConstantUtil.verticalSpacing / 2),

                InlineText(
                    title: widget.selectedTransaction.text
                        .toUpperCase()),

                Row(
                  children: [
                    // period selector
                    ...[
                      ReportPeriod.today,
                      ReportPeriod.thisWeek,
                      ReportPeriod.thisMonth,
                      ReportPeriod.custom,
                    ].map((p) {
                      final isActive = _period == p;
                      final label = switch (p) {
                        ReportPeriod.today => 'Today',
                        ReportPeriod.thisWeek => 'This Week',
                        ReportPeriod.thisMonth => 'This Month',
                        ReportPeriod.custom => 'Custom',
                      };
                      return GestureDetector(
                        onTap: () {
                          setState(() => _period = p);
                          if (p == ReportPeriod.custom) {
                            _pickCustomDate(isStart: true);
                          } else {
                            _loadData(); // ← load real data
                          }
                        },
                        child: AnimatedContainer(
                          duration:
                          const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isActive
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }),

                    if (_period == ReportPeriod.custom) ...[
                      const SizedBox(
                        height: 30,
                        child: VerticalDivider(thickness: 1),
                      ),
                      Row(
                        children: [
                          DateBtn(
                            label: _customStart == null
                                ? 'Start Date'
                                : _formatDate(_customStart!),
                            isSet: _customStart != null,
                            onTap: () =>
                                _pickCustomDate(isStart: true),
                          ),
                          const SizedBox(width: 8),
                          DateBtn(
                            label: _customEnd == null
                                ? 'End Date'
                                : _formatDate(_customEnd!),
                            isSet: _customEnd != null,
                            onTap: () =>
                                _pickCustomDate(isStart: false),
                          ),
                        ],
                      ),
                    ],

                    const Spacer(),

                    // refresh button
                    GestureDetector(
                      onTap: _isLoading ? null : _loadData,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor
                              .withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primaryColor
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: _isLoading
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

                    if (_isExporting)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2),
                      )
                    else
                      Row(
                        children: [
                          CustomActionButton(
                            onTap: _exportExcel,
                            label: 'Excel',
                            color: const Color(0xFF1D6F42),
                            icon: ExcelIconPainter(),
                          ),
                          const SizedBox(width: 6),
                          CustomActionButton(
                            onTap: _exportWord,
                            label: 'Word',
                            color: const Color(0xFF2B579A),
                            icon: WordIconPainter(),
                          ),
                        ],
                      ),
                  ],
                ),

                Divider(
                    thickness: 1.5,
                    color: AppColors.secondaryColor),
                SizedBox(height: ConstantUtil.verticalSpacing / 2),

                // ── Content ───────────────────────────────────
                Expanded(
                  child: _isLoading
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
                      : _totalOrders == 0
                      ? Center(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart_outlined,
                          size: 64,
                          color: Colors.grey
                              .withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No completed orders found',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Try a different date range',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // ── Summary cards ──────────
                        Row(
                          children: _summaries.map((s) {
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: _summaries.last ==
                                      s
                                      ? 0
                                      : ScreenUtil.width *
                                      0.01,
                                ),
                                padding:
                                const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: s.color.withValues(
                                      alpha: 0.07),
                                  borderRadius:
                                  BorderRadius.circular(
                                      12),
                                  border: Border.all(
                                      color: s.color
                                          .withValues(
                                          alpha: 0.2)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration:
                                          BoxDecoration(
                                            color: s.color
                                                .withValues(
                                                alpha:
                                                0.15),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                8),
                                          ),
                                          child: Icon(
                                              s.icon,
                                              color: s.color,
                                              size: 18),
                                        ),
                                        Text(
                                          s.label ==
                                              'Gross Profit'
                                              ? '${((_grossProfit / _totalRevenue) * 100).toStringAsFixed(1)}%'
                                              : '${s.count} orders',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: s.color
                                                .withValues(
                                                alpha:
                                                0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '\$${s.amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: s.color,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(s.label,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color:
                                            Colors.grey)),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ).animate()
// 1. Wait slightly so it appears after the initial screen load
                .fadeIn(delay: 300.ms, duration:
                600.ms)
// 2. Gently slide down from the top (using slideY with a negative begin)
                .slideY(begin: -0.1, end: 0, curve: Curves.easeOutCubic)
// 3. Optional: add a slight blur-to-clear effect for a premium look
                .blur(begin: const Offset(10, 10), end: Offset.zero),

                        SizedBox(
                            height: ConstantUtil
                                .verticalSpacing /
                                2),

                        // ── Charts row ─────────────
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding:
                                const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      12),
                                  border: Border.all(
                                      color: Colors.grey
                                          .withValues(
                                          alpha: 0.15)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    const Text('Daily Sales',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            color: Colors
                                                .black87)),
                                    const SizedBox(height: 4),
                                    Text('Last 7 days',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey
                                                .withValues(
                                                alpha:
                                                0.7))),
                                    const SizedBox(
                                        height: 16),
                                    SizedBox(
                                      height: 160,
                                      child: BarChart(
                                          data: _dailySales),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate()
// 1. Wait slightly so it appears after the initial screen load
                                .fadeIn(delay: 300.ms, duration:
                            600.ms)
// 2. Gently slide down from the top (using slideY with a negative begin)
                                .slideY(begin: -0.1, end: 0, curve: Curves.easeOutCubic)
// 3. Optional: add a slight blur-to-clear effect for a premium look
                                .blur(begin: const Offset(10, 10), end: Offset.zero),
                            SizedBox(
                                width:
                                ScreenUtil.width * 0.015),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding:
                                const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      12),
                                  border: Border.all(
                                      color: Colors.grey
                                          .withValues(
                                          alpha: 0.15)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    const Text(
                                        'Payment Methods',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            color: Colors
                                                .black87)),
                                    const SizedBox(
                                        height: 16),
                                    _paymentBreakdown.isEmpty
                                        ? const Center(
                                        child: Text(
                                            'No payment data',
                                            style: TextStyle(
                                                color: Colors
                                                    .grey,
                                                fontSize:
                                                12)))
                                        : SizedBox(
                                      height: 120,
                                      child: DonutChart(
                                          data:
                                          _paymentBreakdown,
                                          total:
                                          _totalRevenue),
                                    ),
                                    const SizedBox(
                                        height: 12),
                                    ..._paymentBreakdown
                                        .map((p) {
                                      final pct = _totalRevenue >
                                          0
                                          ? (p.amount /
                                          _totalRevenue *
                                          100)
                                          .toStringAsFixed(
                                          1)
                                          : '0.0';
                                      return Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(
                                            bottom: 6),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration:
                                              BoxDecoration(
                                                color: p.color,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    2),
                                              ),
                                            ),
                                            const SizedBox(
                                                width: 8),
                                            Expanded(
                                                child: Text(
                                                    p.method,
                                                    style: const TextStyle(
                                                        fontSize:
                                                        12))),
                                            Text('$pct%',
                                                style: TextStyle(
                                                    fontSize:
                                                    12,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    color: p
                                                        .color)),
                                            const SizedBox(
                                                width: 8),
                                            Text(
                                                '${ConstantUtil.currencySymbol} ${p.amount.toStringAsFixed(0)}',
                                                style: const TextStyle(
                                                    fontSize:
                                                    11,
                                                    color: Colors
                                                        .grey)),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ).animate()
// 1. Wait slightly so it appears after the initial screen load
                                .fadeIn(delay: 300.ms, duration:
                            600.ms)
// 2. Gently slide down from the top (using slideY with a negative begin)
                                .slideY(begin: -0.1, end: 0, curve: Curves.easeOutCubic)
// 3. Optional: add a slight blur-to-clear effect for a premium look
                                .blur(begin: const Offset(10, 10), end: Offset.zero),
                          ],
                        ),

                        SizedBox(
                            height: ConstantUtil
                                .verticalSpacing /
                                2),

                        // ── Bottom row ──────────────
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // top products
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding:
                                const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      12),
                                  border: Border.all(
                                      color: Colors.grey
                                          .withValues(
                                          alpha: 0.15)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    const Text(
                                        'Top Products by Revenue',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            color: Colors
                                                .black87)),
                                    const SizedBox(
                                        height: 12),
                                    Container(
                                      padding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 12,
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .primaryColor
                                            .withValues(
                                            alpha: 0.08),
                                        borderRadius:
                                        BorderRadius
                                            .circular(6),
                                      ),
                                      child: const Row(
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                  'Product',
                                                  style: TextStyle(
                                                      fontSize:
                                                      12,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold))),
                                          Expanded(
                                              child: Text(
                                                  'SKU',
                                                  style: TextStyle(
                                                      fontSize:
                                                      12,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold))),
                                          Expanded(
                                              child: Text(
                                                  'Qty Sold',
                                                  textAlign:
                                                  TextAlign
                                                      .center,
                                                  style: TextStyle(
                                                      fontSize:
                                                      12,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold))),
                                          Expanded(
                                              child: Text(
                                                  'Revenue',
                                                  textAlign:
                                                  TextAlign
                                                      .right,
                                                  style: TextStyle(
                                                      fontSize:
                                                      12,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold))),
                                        ],
                                      ),
                                    ),
                                    _topProducts.isEmpty
                                        ? const Padding(
                                      padding: EdgeInsets
                                          .all(16),
                                      child: Center(
                                          child: Text(
                                              'No product data',
                                              style: TextStyle(
                                                  color: Colors
                                                      .grey,
                                                  fontSize:
                                                  12))),
                                    )
                                        : Column(
                                      children: _topProducts
                                          .asMap()
                                          .entries
                                          .map((e) {
                                        final index =
                                            e.key;
                                        final p = e.value;
                                        final maxRevenue =
                                            _topProducts
                                                .first
                                                .revenue;
                                        final barWidth =
                                        maxRevenue > 0
                                            ? p.revenue /
                                            maxRevenue
                                            : 0.0;

                                        return Container(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal:
                                              12,
                                              vertical:
                                              8),
                                          decoration:
                                          BoxDecoration(
                                            color: index.isOdd
                                                ? Colors.grey.withValues(
                                                alpha:
                                                0.03)
                                                : Colors
                                                .transparent,
                                            border: Border(
                                              bottom:
                                              BorderSide(
                                                color: Colors
                                                    .grey
                                                    .withValues(
                                                    alpha:
                                                    0.1),
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex:
                                                    2,
                                                    child:
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width:
                                                          22,
                                                          height:
                                                          22,
                                                          decoration: BoxDecoration(
                                                            color: index < 3 ? AppColors.primaryColor : Colors.grey.withValues(alpha: 0.2),
                                                            borderRadius: BorderRadius.circular(4),
                                                          ),
                                                          child:
                                                          Center(
                                                            child:
                                                            Text(
                                                              '${index + 1}',
                                                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: index < 3 ? Colors.white : Colors.grey),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width:
                                                            8),
                                                        Expanded(
                                                          child:
                                                          Text(
                                                            p.name,
                                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          p.sku,
                                                          style: const TextStyle(
                                                              fontSize: 11,
                                                              color: Colors.grey))),
                                                  Expanded(
                                                    child: Text(
                                                        '${p.qtySold}',
                                                        textAlign: TextAlign
                                                            .center,
                                                        style: const TextStyle(
                                                            fontSize:
                                                            12)),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        '\$${p.revenue.toStringAsFixed(2)}',
                                                        textAlign: TextAlign
                                                            .right,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: AppColors.primaryColor)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                  height:
                                                  4),
                                              LayoutBuilder(
                                                builder: (context,
                                                    constraints) {
                                                  return Align(
                                                    alignment:
                                                    Alignment
                                                        .centerLeft,
                                                    child:
                                                    Container(
                                                      width: constraints.maxWidth *
                                                          barWidth,
                                                      height:
                                                      3,
                                                      decoration:
                                                      BoxDecoration(
                                                        color: AppColors
                                                            .primaryColor
                                                            .withValues(alpha: 0.4),
                                                        borderRadius:
                                                        BorderRadius.circular(2),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate()
// 1. Wait slightly so it appears after the initial screen load
                                .fadeIn(delay: 300.ms, duration:
                            600.ms)
// 2. Gently slide down from the top (using slideY with a negative begin)
                                .slideY(begin: -0.1, end: 0, curve: Curves.easeOutCubic)
// 3. Optional: add a slight blur-to-clear effect for a premium look
                                .blur(begin: const Offset(10, 10), end: Offset.zero),

                            SizedBox(
                                width:
                                ScreenUtil.width * 0.015),

                            // right column
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  // quick stats
                                  Container(
                                    padding:
                                    const EdgeInsets.all(
                                        16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(
                                          12),
                                      border: Border.all(
                                          color: Colors.grey
                                              .withValues(
                                              alpha: 0.15)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        const Text(
                                            'Quick Stats',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                                color: Colors
                                                    .black87)),
                                        const SizedBox(
                                            height: 12),
                                        StatRow(
                                          label: 'Total Orders',
                                          value:
                                          '$_totalOrders',
                                          icon: Icons
                                              .receipt_long_outlined,
                                          color: AppColors
                                              .primaryColor,
                                        ),
                                        StatRow(
                                          label: 'Items Sold',
                                          value:
                                          '$_totalItemsSold',
                                          icon: Icons
                                              .inventory_2_outlined,
                                          color: Colors.orange,
                                        ),
                                        StatRow(
                                          label:
                                          'Profit Margin',
                                          value: _totalRevenue >
                                              0
                                              ? '${((_grossProfit / _totalRevenue) * 100).toStringAsFixed(1)}%'
                                              : '0.0%',
                                          icon: Icons
                                              .pie_chart_outline,
                                          color: Colors.green,
                                        ),
                                        StatRow(
                                          label:
                                          'Avg Items/Order',
                                          value: _totalOrders >
                                              0
                                              ? '${(_totalItemsSold / _totalOrders).toStringAsFixed(1)}'
                                              : '0.0',
                                          icon: Icons
                                              .shopping_cart_outlined,
                                          color: Colors.purple,
                                        ),
                                        StatRow(
                                          label: 'Best Day',
                                          value: _dailySales
                                              .every((d) =>
                                          d.amount ==
                                              0)
                                              ? 'N/A'
                                              : _formatDate(
                                              _dailySales
                                                  .reduce((a,
                                                  b) =>
                                              a.amount >
                                                  b.amount
                                                  ? a
                                                  : b)
                                                  .date),
                                          icon:
                                          Icons.star_outline,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                      height: ConstantUtil
                                          .verticalSpacing /
                                          2),

                                  // revenue vs cost
                                  Container(
                                    padding:
                                    const EdgeInsets.all(
                                        16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(
                                          12),
                                      border: Border.all(
                                          color: Colors.grey
                                              .withValues(
                                              alpha: 0.15)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        const Text(
                                            'Revenue vs Cost',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                                color: Colors
                                                    .black87)),
                                        const SizedBox(
                                            height: 12),
                                        ProgressBar(
                                          label: 'Revenue',
                                          value: _totalRevenue,
                                          max: _totalRevenue,
                                          color: AppColors
                                              .primaryColor,
                                        ),
                                        const SizedBox(
                                            height: 8),
                                        ProgressBar(
                                          label: 'Cost',
                                          value: _totalCost,
                                          max: _totalRevenue,
                                          color: Colors.orange,
                                        ),
                                        const SizedBox(
                                            height: 8),
                                        ProgressBar(
                                          label: 'Profit',
                                          value: _grossProfit,
                                          max: _totalRevenue,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ).animate()
// 1. Wait slightly so it appears after the initial screen load
                                .fadeIn(delay: 300.ms, duration:
                            600.ms)
// 2. Gently slide down from the top (using slideY with a negative begin)
                                .slideY(begin: -0.1, end: 0, curve: Curves.easeOutCubic)
// 3. Optional: add a slight blur-to-clear effect for a premium look
                                .blur(begin: const Offset(10, 10), end: Offset.zero),
                          ],
                        ),

                        SizedBox(
                            height:
                            ConstantUtil.verticalSpacing),
                      ],
                    ),
                  ),
                ),
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
}

// ── Helper for aggregating product sales ──────────────────────
class _ProductAgg {
  final String name;
  final String sku;
  int qtySold;
  double revenue;

  _ProductAgg({
    required this.name,
    required this.sku,
    required this.qtySold,
    required this.revenue,
  });
}