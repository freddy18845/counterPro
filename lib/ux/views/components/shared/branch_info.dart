import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../res/app_theme.dart';
import '../../../utils/shared/screen.dart';

class BranchInfo extends StatefulWidget {
  const BranchInfo({super.key});

  @override
  State<BranchInfo> createState() => _BranchInfoState();
}

class _BranchInfoState extends State<BranchInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: ConstantUtil.verticalSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRowCard(
            title: AppStrings.location,
            text: ConstantUtil.defaultMerchantLocation,
          ),
          AppTheme.buildVerticalDivider(color: Colors.grey),
          _buildRowCard(
            title: AppStrings.branch,
            text: ConstantUtil.defaultMerchantName,
          ),
          AppTheme.buildVerticalDivider(color: Colors.grey),
          _buildRowCard(
            title: AppStrings.businessId_,
            text: ConstantUtil.defaultBusinessID,
          ),
          AppTheme.buildVerticalDivider(color: Colors.grey),
          _buildRowCard(title: AppStrings.country, text: AppStrings.eswatini),
        ],
      ),
    );
  }

  Widget _buildRowCard({required String title, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTheme.getTextStyle(
            bold: true,
            color: Colors.grey,
            size: (ScreenUtil.height * 0.02).clamp(10, 12),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          text,
          style: AppTheme.getTextStyle(
            color: Colors.grey,
            size: (ScreenUtil.height * 0.02).clamp(10, 12),
          ),
        ),
      ],
    );
  }
}
