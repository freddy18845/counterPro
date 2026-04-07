// lib/ux/views/components/dialogs/payment_upgrade_dialog.dart
import 'package:eswaini_destop_app/platform/utils/isar_manager.dart';
import 'package:eswaini_destop_app/ux/models/shared/company.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:eswaini_destop_app/ux/utils/sessionManager.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../../../platform/utils/constant.dart';
import '../../../models/shared/price_model.dart';
import '../../../models/shared/step_row.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_drawables.dart';
import '../../../utils/api_service.dart';
import '../../../utils/shared/subscriptionManger.dart';
import '../shared/btn.dart';
import '../shared/login_input.dart';

class PaymentUpgradeDialog extends StatefulWidget {
  final double amount;
  final String type;
  final String planName;
  final Color planColor;

  const PaymentUpgradeDialog({
    super.key,
    required this.amount,
    required this.type,
    required this.planName,
    this.planColor = AppColors.primaryColor,
  });

  @override
  State<PaymentUpgradeDialog> createState() =>
      _PaymentUpgradeDialogState();
}

class _PaymentUpgradeDialogState
    extends State<PaymentUpgradeDialog> {
  // ← use AuthApiService — that's where the methods live
  final _authApi = AuthApiService();

  String? _activeReference;
  String? _authorizationUrl;
  bool _isProcessing = false;
  bool _paymentOpened = false;

  late TextEditingController _monthsController;
  int _selectedMonths = 1;
  String? _monthsError;

  @override
  void initState() {
    super.initState();
    _monthsController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _monthsController.dispose();
    super.dispose();
  }

  double get _totalAmount => widget.amount * _selectedMonths;

  double get _discountedTotal {
    final savings = _getSavings(_selectedMonths);
    return savings > 0
        ? _totalAmount * (1 - savings / 100)
        : _totalAmount;
  }

  int _getSavings(int months) {
    if (months >= 12) return 15;
    if (months >= 6) return 10;
    if (months >= 3) return 5;
    return 0;
  }

  void _updateMonths(String value) {
    setState(() {
      _monthsError = null;
      if (value.isEmpty) {
        _monthsError = 'Please enter number of months';
        return;
      }
      final parsed = int.tryParse(value);
      if (parsed == null) {
        _monthsError = 'Please enter a valid number';
        return;
      }
      if (parsed < 1) {
        _monthsError = 'Minimum 1 month required';
        return;
      }
      if (parsed > 24) {
        _monthsError = 'Maximum 24 months allowed';
        return;
      }
      _selectedMonths = parsed;
    });
  }

  // ── Get customer email ────────────────────────────────────
  String get _customerEmail =>
      SessionManager().userEmail ??
          SessionManager().companyEmail ??
          'fredoppong89@gmail.com';

  // ── Step 1 — Initialize payment ───────────────────────────
  Future<void> _handleProceedToPayment() async {
    if (_monthsError != null) {
      _showSnack(_monthsError!, Colors.red);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // ← call AuthApiService.initializePayment
      final data = await _authApi.initializePayment(
        amount: _discountedTotal,
        email: _customerEmail,
      );

      if (data == null) {
        _showSnack(
            '❌ Could not initialize payment. Try again.',
            Colors.red);
        setState(() => _isProcessing = false);
        return;
      }

      // save reference and authorization url from response
      setState(() {
        _activeReference   = data['reference'] as String?;
        _authorizationUrl  = data['authorization_url'] as String?;
        _isProcessing      = false;
        _paymentOpened     = false;
      });

      // open payment page in browser
      if (_authorizationUrl != null) {
        await _authApi.openPaymentPage(_authorizationUrl!);
        setState(() => _paymentOpened = true);
        _showSnack(
            '✅ Payment page opened. Complete payment then tap Verify.',
            Colors.blue);
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showSnack('❌ Payment error: $e', Colors.red);
    }
  }

  // ── Step 2 — Verify payment ───────────────────────────────
  Future<void> _handleVerifyPayment() async {
    if (_activeReference == null) return;

    setState(() => _isProcessing = true);

    try {
      // ← call AuthApiService.verifyPayment
      final success =
      await _authApi.verifyPayment(_activeReference!);

      if (!success) {
        setState(() => _isProcessing = false);
        _showSnack(
            '❌ Payment not confirmed yet. Please complete payment in browser first.',
            Colors.orange);
        return;
      }

      // ── Activate subscription locally ────────────────
      await _activateSubscription();

      setState(() => _isProcessing = false);

      if (mounted) {
        _showSnack(
            '✅ ${widget.planName} plan activated!',
            Colors.green);
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showSnack('❌ Verification failed: $e', Colors.red);
    }
  }

  // ── Activate subscription in Isar ────────────────────────
  Future<void> _activateSubscription() async {
    final isar = IsarService.db;
    final company = await isar.companys.where().findFirst();
    if (company == null) return;

    await isar.writeTxn(() async {
      company
        ..subscriptionPlan   = _parsePlan(widget.type)
        ..subscriptionStatus = SubscriptionStatus.active
        ..subscriptionStartDate = DateTime.now()
        ..subscriptionEndDate = DateTime.now().add(
            Duration(days: 30 * _selectedMonths))
        ..updatedAt = DateTime.now();
      await isar.companys.put(company);
    });

  ///  await SubscriptionManager().refresh();
  }

  SubscriptionPlan _parsePlan(String type) {
    switch (type.toLowerCase()) {
      case 'pro':        return SubscriptionPlan.pro;
      case 'enterprise': return SubscriptionPlan.enterprise;
      default:           return SubscriptionPlan.basic;
    }
  }

  void _showSnack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ───────────────────────────────
              Icon(Icons.workspace_premium,
                  color: widget.planColor, size: 48),
              const SizedBox(height: 12),
              Text(
                'Upgrade to ${widget.planName}'
                    .toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.planColor,
                ),
              ),

              const SizedBox(height: 8),

              // billing email
              Text(
                'Billing to: $_customerEmail',
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // ── Months selection ──────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.planColor
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: widget.planColor
                          .withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    InputField(
                      label: 'Number of Months',
                      controller: _monthsController,
                      hintText: 'Enter months (1–24)',
                      prexIcon:
                      Icons.calendar_today_outlined,
                      keyboardType: TextInputType.number,
                      enabled: !_isProcessing &&
                          !_paymentOpened,
                      //onChanged: _updateMonths,
                      validator: (v) => _monthsError,
                    ),
                    if (_monthsError != null) ...[
                      const SizedBox(height: 4),
                      Text(_monthsError!,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Colors.red)),
                    ],
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [1, 3, 6, 12].map((m) {
                        final isSelected =
                            _selectedMonths == m;
                        return GestureDetector(
                          onTap: _paymentOpened
                              ? null
                              : () {
                            _monthsController
                                .text = m.toString();
                            _updateMonths(
                                m.toString());
                          },
                          child: AnimatedContainer(
                            duration: const Duration(
                                milliseconds: 150),
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? widget.planColor
                                  : Colors.grey.withValues(
                                  alpha: 0.1),
                              borderRadius:
                              BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? widget.planColor
                                    : Colors.grey.withValues(
                                    alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              '$m month${m > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Price summary ─────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border:
                  Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  children: [
                    PriceRow(
                        label: 'Monthly price',
                        value:
                        '${ConstantUtil.currencySymbol}${widget.amount.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    PriceRow(
                        label: 'Duration',
                        value:
                        '$_selectedMonths month${_selectedMonths > 1 ? 's' : ''}'),
                    if (_getSavings(_selectedMonths) > 0) ...[
                      const SizedBox(height: 8),
                      PriceRow(
                        label: 'Discount',
                        value:
                        '${_getSavings(_selectedMonths)}% off',
                        valueColor: Colors.green,
                        bold: true,
                      ),
                    ],
                    const Divider(height: 20),
                    PriceRow(
                      label: 'Total',
                      value:
                      '${ConstantUtil.currencySymbol}${_discountedTotal.toStringAsFixed(2)}',
                      valueColor: Colors.green,
                      labelSize: 18,
                      valueSize: 20,
                      bold: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Steps ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    StepRow(
                        number: '1',
                        text:
                        'Click "Proceed to payment" to open the checkout',
                        done: _paymentOpened,
                        color: widget.planColor),
                    const SizedBox(height: 10),
                    StepRow(
                        number: '2',
                        text:
                        'Complete payment in the browser tab',
                        done: _paymentOpened,
                        color: widget.planColor),
                    const SizedBox(height: 10),
                    StepRow(
                        number: '3',
                        text:
                        'Come back and tap "Verify payment" to finish',
                        done: false,
                        color: widget.planColor),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Buttons ───────────────────────────────
              if (_isProcessing)
                Column(
                  children: [CircularProgressIndicator(strokeWidth: 2 ,color:widget.planColor ,),
                    const SizedBox(height: 8),
                    const Text(AppStrings.processingPleaseWait,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey)),
                  ],
                )
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: Btn(
                        text: _paymentOpened
                            ? 'Reopen Payment'
                            : 'Proceed to payment',
                        onTap: _handleProceedToPayment,
                        bgImage: AppDrawables.greenCard,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Btn(
                        text: 'Verify payment',
                        onTap: _activeReference == null
                            ? () {}
                            : _handleVerifyPayment,
                        isActive: _activeReference != null,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              // ── Paystack badge ────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline,
                      size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text(
                    'Secured by Paystack',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              TextButton(
                onPressed: _isProcessing
                    ? null
                    : () => Navigator.pop(context),
                child: const Text('Cancel',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



