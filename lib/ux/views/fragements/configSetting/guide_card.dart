import 'package:eswaini_destop_app/ux/views/fragements/configSetting/step_row.dart';
import 'package:flutter/cupertino.dart';

import '../../../res/app_colors.dart';
import '../../components/screens/configSetting/section_title.dart';

class GuideCard extends StatelessWidget {
  const GuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return   Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── API key info ──────────────────────────────
          SectionTitle(title: 'How to get your API Key'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StepRow(
                  step: '1',
                  text:
                  'Make Sure You Have Internet Access',
                ),
                StepRow(
                  step: '2',
                  text: 'Look Below the Screen And You Will Your Company Info ',
                ),
                StepRow(
                  step: '3',
                  text: 'Contact Support ( 0542158570 / 0560718845 )\n\n Will Provide You With  Dedicated Url ',
                ),
                StepRow(
                  step: '4',
                  text: 'Copy the BID And Paste It In the Api Key',
                ),
                StepRow(
                  step: '5',
                  text: 'Click "Test Connection" to Verify',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
