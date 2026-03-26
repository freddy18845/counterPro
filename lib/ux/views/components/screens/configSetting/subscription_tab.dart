import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/section_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../res/app_colors.dart';
import '../../../../utils/shared/app.dart';

class SubscriptionTab extends StatelessWidget {
  const SubscriptionTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'Current Plan'),
          const SizedBox(height: 12),

          // current plan card
          Container(
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
                      const Text('Pro Plan',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Active until 31 Dec 2025',
                          style: TextStyle(
                              color: Colors.white
                                  .withValues(alpha: 0.8),
                              fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Active',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ],
            ),
          ),

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
                  '1 User',
                  'Up to 100 products',
                  'Basic reports',
                  'Email support',
                ],
                isActive: false,
                color: Colors.grey,
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
                isActive: true,
                color: AppColors.primaryColor,
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
                isActive: false,
                color: Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final List<String> features;
  final bool isActive;
  final Color color;

  const PlanCard({
    required this.name,
    required this.price,
    required this.features,
    required this.isActive,
    required this.color,
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
                onPressed: isActive
                    ? null
                    : () => AppUtil.toastMessage(
                  message:
                  'Subscription upgrade coming soon',
                  context: context,
                  backgroundColor: color,
                ),
                child: Text(
                    isActive ? 'Current Plan' : 'Upgrade',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}