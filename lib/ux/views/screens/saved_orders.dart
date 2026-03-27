import "dart:async";
import "package:eswaini_destop_app/ux/models/screens/home/flow_item.dart";
import "package:eswaini_destop_app/ux/res/app_theme.dart";
import "package:eswaini_destop_app/ux/views/components/dialogs/message.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "../../../platform/utils/constant.dart";
import "../../../platform/utils/isar_manager.dart";
import "../../models/shared/sale_order.dart";
import "../../res/app_colors.dart";
import "../../utils/shared/app.dart";
import "../../utils/shared/screen.dart";
import "../components/dialogs/order_details_dailog.dart";
import "../components/screens/Report/date_btn.dart";
import "../components/screens/savedOrders/oder_table_row.dart";
import "../components/shared/card_widget.dart";
import "../components/shared/inline_text.dart";
import "../components/shared/login_input.dart";
import "../components/shared/pagination.dart";
import "../components/shared/ui_template.dart";
import "../components/dialogs/payment_dailog.dart";
import "../fragements/shared/cart_item.dart";

class SavedOrdersScreen extends StatefulWidget {
  final HomeFlowItem selectedTransaction;
  const SavedOrdersScreen({
    super.key,
    required this.selectedTransaction,
  });

  @override
  State<SavedOrdersScreen> createState() => _SavedOrdersScreenState();
}

class _SavedOrdersScreenState extends State<SavedOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final isar = IsarService.db;

  SaleOrderStatus? _statusFilter;
  DateTime? _startDate;
  DateTime? _endDate;

  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _currentPage = 1);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Filter ────────────────────────────────────────────────────
  List<SaleOrder> _filterOrders(List<SaleOrder> all) {
    final query = _searchController.text.trim().toLowerCase();
    return all.where((o) {
      if (o.status == SaleOrderStatus.completed) return false;
      final matchesSearch = query.isEmpty ||
          o.orderNumber.toLowerCase().contains(query) ||
          o.totalAmount.toStringAsFixed(2).contains(query) ||
          (o.customerName?.toLowerCase().contains(query) ?? false);

      final matchesStatus =
          _statusFilter == null || o.status == _statusFilter;

      final matchesStart =
          _startDate == null || !o.createdAt.isBefore(_startDate!);
      final matchesEnd = _endDate == null ||
          !o.createdAt.isAfter(
              _endDate!.add(const Duration(hours: 23, minutes: 59)));

      return matchesSearch && matchesStatus && matchesStart && matchesEnd;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<T> _paginate<T>(List<T> all) {
    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, all.length);
    if (start >= all.length) return [];
    return all.sublist(start, end);
  }

  int _totalPages() => (_totalItems / _pageSize).ceil().clamp(1, 999);

  Future<void> _pickDate({required bool isStart}) async {
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
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _currentPage = 1;
      });
    }
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _statusFilter = null;
      _startDate = null;
      _endDate = null;
      _currentPage = 1;
    });
  }

  // ── Resume saved order → go to payment ───────────────────────
  Future<void> _resumeOrder(SaleOrder order) async {
    final result = await AppUtil.displayDialog(
      context: context,
      dismissible: false,
      child: PaymentDialog(
        total: order.totalAmount,
        subtotal: order.subtotal,
        tax: order.taxAmount,
        cart: order.items
            .map((item) => CartItemFromOrder(item: item))
            .toList(),
        existingOrderId: order.id, transactionId:AppTheme.generateTransactionId(),
      ),
    );

    if (result == true) {
      // mark order as completed
      await isar.writeTxn(() async {
        order.status = SaleOrderStatus.completed;
        order.completedAt = DateTime.now();
        await isar.saleOrders.put(order);
      });
    }
  }

  // ── Cancel order ──────────────────────────────────────────────
  Future<void> _cancelOrder(SaleOrder order) async {
    final confirm = await AppUtil.displayDialog(
      context: context,
      dismissible: false,
      child: MessageDialog( title:  'Cancel Order?', message: ' Are you sure you want to cancel order ${order.orderNumber}? This cannot be undone.',),
    );

    if (confirm == true) {
      await isar.writeTxn(() async {
        order.status = SaleOrderStatus.cancelled;
        await isar.saleOrders.put(order);
      });

      if (mounted) {
        AppUtil.toastMessage(
          message: '✅ Order ${order.orderNumber} cancelled',
          context: context,
          backgroundColor: Colors.orange,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      contentSection: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ConstantUtil.verticalSpacing / 2),
            InlineText(
              title: widget.selectedTransaction.text.toUpperCase(),
            ),
            SizedBox(height: ConstantUtil.verticalSpacing / 4),

            // ── Filters ───────────────────────────────────
            Row(
              children: [
                // search
                SizedBox(
                  width: (ScreenUtil.width * 0.2).clamp(160, 280),
                  child: ConfigField(
                    controller: _searchController,
                    hintText: 'Order No, Amount',
                    enabled: true,
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(width: ScreenUtil.width * 0.01),

                // status filter
                SizedBox(
                  width: (ScreenUtil.width * 0.12).clamp(120, 180),
                  child: DropdownButtonFormField<SaleOrderStatus?>(
                    value: _statusFilter,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                    ),
                    hint: const Text('All Status',
                        style: TextStyle(fontSize: 12)),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Status',
                            style: TextStyle(fontSize: 12)),
                      ),
                      ...SaleOrderStatus.values.map((s) =>
                          DropdownMenuItem(
                            value: s,
                            child: Text(
                              _statusLabel(s),
                              style: const TextStyle(fontSize: 12),
                            ),
                          )),
                    ],
                    onChanged: (val) => setState(() {
                      _statusFilter = val;
                      _currentPage = 1;
                    }),
                  ),
                ),
                Spacer(),

                // start date
                DateBtn(
                  label: _startDate == null
                      ? 'Start Date'
                      : _formatDate(_startDate!),
                  isSet: _startDate != null,
                  onTap: () => _pickDate(isStart: true),
                ),
                SizedBox(width: ScreenUtil.width * 0.008),

                // end date
                DateBtn(
                  label: _endDate == null
                      ? 'End Date'
                      : _formatDate(_endDate!),
                  isSet: _endDate != null,
                  onTap: () => _pickDate(isStart: false),
                ),

                const Spacer(),

                // clear filters
                if (_startDate != null ||
                    _endDate != null ||
                    _statusFilter != null ||
                    _searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: _clearFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.close,
                              size: 14, color: Colors.red),
                          SizedBox(width: 4),
                          Text('Clear',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.red)),
                        ],
                      ),
                    ),
                  ),

              ],
            ),

            SizedBox(height: ConstantUtil.verticalSpacing / 2),
            Divider(
                thickness: 1.5, color: AppColors.secondaryColor),
            SizedBox(height: ConstantUtil.verticalSpacing / 4),

            // ── Table ─────────────────────────────────────
            Expanded(
              child: StreamBuilder<List<SaleOrder>>(
                stream: isar.saleOrders
                    .where()
                    .watch(fireImmediately: true),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child:    CupertinoActivityIndicator(radius: 18, color: Colors.green));
                  }

                  final filtered =
                  _filterOrders(snapshot.data!);

                  // update total for pagination
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) {
                    if (_totalItems != filtered.length) {
                      setState(() {
                        _totalItems = filtered.length;
                        _currentPage = 1;
                      });
                    }
                  });

                  final paged = _paginate(filtered);

                  if (paged.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined,
                              size: 48,
                              color: Colors.grey
                                  .withValues(alpha: 0.4)),
                          const SizedBox(height: 8),
                          const Text('No orders found',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13)),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // header
                      OrderTableRow(
                        isHeader: true,
                        cells: const [
                          'Order No',
                          'Date',
                          'Items',
                          'Total',
                          'Status',
                        ],
                      ),

                      // rows
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: paged.length,
                          itemBuilder: (context, index) {
                            final order = paged[index];
                            return OrderTableRow(
                              isHeader: false,
                              isAlternate: index.isOdd,
                              order: order,
                              cells: [
                                order.orderNumber,
                                _formatDate(order.createdAt),
                                '${order.items.length} item${order.items.length != 1 ? 's' : ''}',
                                '${ConstantUtil.currencySymbol} ${order.totalAmount.toStringAsFixed(2)}',
                                _statusLabel(order.status),
                              ],
                              onResume: order.status ==
                                  SaleOrderStatus.saved
                                  ? () => _resumeOrder(order)
                                  : null,
                              onCancel: order.status ==
                                  SaleOrderStatus.saved
                                  ? () => _cancelOrder(order)
                                  : null,
                              onView: () => _viewOrderDetails(
                                  context, order),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ── Divider + Pagination ──────────────────────
            Divider(
                thickness: 1.5, color: AppColors.secondaryColor),
            Pagination(
              currentPage: _currentPage,
              totalPages: _totalPages(),
              totalItems: _totalItems,
              pageSize: _pageSize,
              onPageChanged: (p) =>
                  setState(() => _currentPage = p),
            ),
            SizedBox(height: ConstantUtil.verticalSpacing / 2),
          ],
        ),
      ),
    );
  }

  // ── View order details dialog ─────────────────────────────────
  void _viewOrderDetails(BuildContext context, SaleOrder order) {
    AppUtil.displayDialog(
      context: context,
      dismissible: true,
      child: OrderDetailsDialog(order: order),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/'
          '${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  String _statusLabel(SaleOrderStatus s) {
    switch (s) {
      case SaleOrderStatus.saved:
        return 'Saved';
      case SaleOrderStatus.completed:
        return 'Completed';
      case SaleOrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}





