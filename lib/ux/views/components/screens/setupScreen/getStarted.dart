// ─────────────────────────────────────────────────────────────
// ── GET STARTED CARD (fresh setup — no API needed) ────────────
// ─────────────────────────────────────────────────────────────
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../nav/app_navigator.dart';
import '../../../../res/app_colors.dart';
import '../../../../utils/shared/api_config.dart';
import '../../../../utils/shared/screen.dart';
import '../../shared/btn.dart';

class GetStartedCard extends StatelessWidget {
  const GetStartedCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: (ScreenUtil.width * 0.55).clamp(320, 600),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardOutlineColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // header
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.rocket_launch_outlined,
                    color: AppColors.primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Text(
                      'Set Up your business from scratch',
                      style: TextStyle(
                        fontSize: 12, ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),

          // what you get
          const Text(
            'What you will set up:',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 12),

          ...[
            ('🏢', 'Company profile & branding'),
            ('👤', 'Admin account & password'),
            ('📦', 'Products & categories'),
            ('🖨', 'Printer & settings'),
          ].map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(item.$1,
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Text(item.$2,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87)),
              ],
            ),
          )),

          const SizedBox(height: 20),

          // info box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline,
                    size: 16, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You can connect to the server later in Settings → API & Sync to backup your data.',
                    style: TextStyle(
                        fontSize: 11, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ColorBtn(
              text: 'Start Setup  →',
              btnColor: AppColors.primaryColor,
              action: () {

    ApiConfig.clearAll();
    AppNavigator.gotoRegistration(
    context: context
    );
    }
            )
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.05, end: 0);
  }
}