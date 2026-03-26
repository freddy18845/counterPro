import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:eswaini_destop_app/ux/utils/sessionManager.dart';
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
 final sessionManager = SessionManager();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ConstantUtil.verticalSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRowCard(
            title: AppStrings.company,
            text: sessionManager.company!.name,
          ),

          AppTheme.buildVerticalDivider(color: Colors.grey),
          _buildRowCard(
            title: AppStrings.bid_,
            text: '${sessionManager.company!.companyId}',
          ),
          AppTheme.buildVerticalDivider(color: Colors.grey),
          _buildRowCard(
            title: AppStrings.address,
            text: sessionManager.company!.address,
          ),
          AppTheme.buildVerticalDivider(color: Colors.grey),
          _buildRowCard(
            title: AppStrings.email,
            text: sessionManager.company!.email,
          ),
          AppTheme.buildVerticalDivider(color: Colors.grey),
          _buildRowCard(title: AppStrings.phone, text: "${sessionManager.company!.contactOne} ,${sessionManager.company!.contactTwo}"),
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
