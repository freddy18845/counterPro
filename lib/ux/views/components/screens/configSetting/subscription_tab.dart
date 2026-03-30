
import 'package:eswaini_destop_app/ux/models/shared/company.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_user.dart';
import 'package:eswaini_destop_app/ux/models/shared/product.dart';
import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/section_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../../../../../platform/utils/isar_manager.dart';
import '../../../../res/app_colors.dart';
import '../../../../utils/shared/subscriptionManger.dart';

class SubscriptionTab extends StatefulWidget {
  const SubscriptionTab({super.key});

  @override
  State<SubscriptionTab> createState() => _SubscriptionTabState();
}

class _SubscriptionTabState extends State<SubscriptionTab> {
  bool _isLoading = true;
  late SubscriptionManager _sub;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _sub = SubscriptionManager();
    await _sub.refresh();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CupertinoActivityIndicator(radius: 18, color: Colors.green));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'Current Plan'),
          const SizedBox(height: 12),

          // ── Current plan card ─────────────────────────
          _CurrentPlanCard(sub: _sub),

          // ── Expiry warning ────────────────────────────
          if (_sub.isExpiringSoon || _sub.isExpired) ...[
            const SizedBox(height: 12),
            _ExpiryWarning(sub: _sub),
          ],

          const SizedBox(height: 20),
          SectionTitle(title: 'Available Plans'),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlanCard(
                name: 'Basic',
                price: '\$9.99/mo',
                features: const [
                  '1 User — Admin only',
                  'Up to 70 products',
                  'Basic reports',
                  'Email support',
                ],
                isActive: _sub.plan == SubscriptionPlan.basic,
                color: Colors.grey,
                onUpgrade: () => _handleUpgrade('Basic', context),
              ),
              const SizedBox(width: 12),
              PlanCard(
                name: 'Pro',
                price: '\$24.99/mo',
                features: const [
                  'Up to 5 Users',
                  'Unlimited products',
                  'Advanced reports',
                  'Export to Excel/Word',
                  'Priority support',
                ],
                isActive: _sub.plan == SubscriptionPlan.pro,
                color: AppColors.primaryColor,
                onUpgrade: () => _handleUpgrade('Pro', context),
              ),
              const SizedBox(width: 12),
              PlanCard(
                name: 'Enterprise',
                price: '\$59.99/mo',
                features: const [
                  'Unlimited Users',
                  'Unlimited products',
                  'Custom reports',
                  'API access',
                  'Dedicated support',
                  'Multi-branch',
                ],
                isActive: _sub.plan == SubscriptionPlan.enterprise,
                color: Colors.purple,
                onUpgrade: () => _handleUpgrade('Enterprise', context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Plan limits summary ───────────────────────
          SectionTitle(title: 'Your Current Limits'),
          const SizedBox(height: 12),
          _LimitsSummary(sub: _sub),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _handleUpgrade(String planName, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _UpgradeDialog(planName: planName),
    );
  }
}

// ── Current plan card ─────────────────────────────────────────
class _CurrentPlanCard extends StatelessWidget {
  final SubscriptionManager sub;
  const _CurrentPlanCard({required this.sub});

  Color get _statusColor {
    if (sub.isExpired) return Colors.red;
    if (sub.isExpiringSoon) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppColors.primaryColor,
          AppColors.primaryColor.withValues(alpha: 0.7),
        ]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium,
              color: Colors.amber, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${sub.planName} Plan',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sub.endDate != null
                      ? sub.isExpired
                      ? 'Expired on ${DateFormat('dd MMM yyyy').format(sub.endDate!)}'
                      : 'Active until ${DateFormat('dd MMM yyyy').format(sub.endDate!)}'
                      : 'No expiry date set',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
                if (sub.isExpiringSoon && !sub.isExpired)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '⚠️ ${sub.daysLeft} days remaining',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              sub.statusLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Expiry warning banner ─────────────────────────────────────
class _ExpiryWarning extends StatelessWidget {
  final SubscriptionManager sub;
  const _ExpiryWarning({required this.sub});

  @override
  Widget build(BuildContext context) {
    final isExpired = sub.isExpired;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isExpired
            ? Colors.red.withValues(alpha: 0.08)
            : Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isExpired
              ? Colors.red.withValues(alpha: 0.4)
              : Colors.orange.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isExpired
                ? Icons.cancel_outlined
                : Icons.warning_amber_outlined,
            color: isExpired ? Colors.red : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isExpired
                  ? 'Your subscription has expired. Some features may be restricted. Please renew to continue using CounterPro.'
                  : 'Your subscription expires in ${sub.daysLeft} days. Renew now to avoid interruption.',
              style: TextStyle(
                fontSize: 12,
                color: isExpired ? Colors.red : Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) => _UpgradeDialog(
                  planName: SubscriptionManager().planName),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isExpired ? Colors.red : Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Renew',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Limits summary ────────────────────────────────────────────
class _LimitsSummary extends StatefulWidget {
  final SubscriptionManager sub;
  const _LimitsSummary({required this.sub});

  @override
  State<_LimitsSummary> createState() => _LimitsSummaryState();
}

class _LimitsSummaryState extends State<_LimitsSummary> {
  int _userCount = 0;
  int _productCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final isar = IsarService.db;
    final users = await isar.posUsers.where().count();
    final products = await isar.products.where().count();
    setState(() {
      _userCount = users;
      _productCount = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          _LimitRow(
            icon: Icons.people_outlined,
            label: 'Users',
            used: _userCount,
            max: widget.sub.maxUsers,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 12),
          _LimitRow(
            icon: Icons.inventory_2_outlined,
            label: 'Products',
            used: _productCount,
            max: widget.sub.maxProducts,
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          // feature flags
          Row(
            children: [
              _FeatureChip(
                label: 'Export',
                enabled: widget.sub.canExport,
              ),
              const SizedBox(width: 8),
              _FeatureChip(
                label: 'Advanced Reports',
                enabled: widget.sub.hasAdvancedReports,
              ),
              const SizedBox(width: 8),
              _FeatureChip(
                label: 'API Access',
                enabled: widget.sub.hasApiAccess,
              ),
              const SizedBox(width: 8),
              _FeatureChip(
                label: 'Multi-Branch',
                enabled: widget.sub.hasMultiBranch,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LimitRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int used;
  final int max;
  final Color color;

  const _LimitRow({
    required this.icon,
    required this.label,
    required this.used,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlimited = max >= 999999;
    final ratio = isUnlimited ? 0.0 : (used / max).clamp(0.0, 1.0);
    final isNearLimit = !isUnlimited && ratio >= 0.8;

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 12, color: Colors.black87),
          ),
        ),
        Expanded(
          child: isUnlimited
              ? Row(
            children: [
              const SizedBox(width: 8),
              Text(
                '$used / Unlimited',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )
              : Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor:
                    Colors.grey.withValues(alpha: 0.2),
                    color: isNearLimit
                        ? Colors.orange
                        : color,
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$used / $max',
                style: TextStyle(
                  fontSize: 12,
                  color: isNearLimit
                      ? Colors.orange
                      : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;
  final bool enabled;

  const _FeatureChip({required this.label, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: enabled
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: enabled
              ? Colors.green.withValues(alpha: 0.4)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            enabled
                ? Icons.check_circle_outline
                : Icons.cancel_outlined,
            size: 12,
            color: enabled ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: enabled ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Upgrade dialog ────────────────────────────────────────────
class _UpgradeDialog extends StatelessWidget {
  final String planName;
  const _UpgradeDialog({required this.planName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium,
                color: Colors.amber, size: 48),
            const SizedBox(height: 12),
            Text(
              'Upgrade to $planName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'To upgrade your subscription please contact CounterPro support. Our team will process your upgrade and update your account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // contact options
            _ContactRow(
              icon: Icons.email_outlined,
              label: 'support@counterproapp.com',
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 8),
            _ContactRow(
              icon: Icons.language_outlined,
              label: 'counterproapp.com',
              color: Colors.blue,
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border:
        Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ── Plan card ─────────────────────────────────────────────────
class PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final List<String> features;
  final bool isActive;
  final Color color;
  final VoidCallback onUpgrade;

  const PlanCard({
    super.key,
    required this.name,
    required this.price,
    required this.features,
    required this.isActive,
    required this.color,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: 0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? color
                : Colors.grey.withValues(alpha: 0.2),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color)),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius:
                        BorderRadius.circular(20)),
                    child: const Text('Current',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(price,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 12),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 14, color: color),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(f,
                          style: const TextStyle(
                              fontSize: 12))),
                ],
              ),
            )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isActive ? Colors.grey : color),
                onPressed: isActive ? null : onUpgrade,
                child: Text(
                    isActive ? 'Current Plan' : 'Upgrade',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}