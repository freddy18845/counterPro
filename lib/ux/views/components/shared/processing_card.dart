import 'package:eswaini_destop_app/ux/models/screens/home/flow_item.dart';
import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:flutter/material.dart';
import '../../../../platform/utils/constant.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_drawables.dart';
import '../../../res/app_strings.dart';
import '../../../utils/shared/screen.dart';
import 'btn.dart';
import 'card_widget.dart';
import 'inline_text.dart';

class ProcessingCard extends StatelessWidget {
  final Widget child;
  final bool isProcessing;
  final bool isSuccessful;
  final HomeFlowItem metaData;
  final VoidCallback? onAction;
  final VoidCallback? onCancel;

  const ProcessingCard({
    super.key,
    required this.child,
    required this.isProcessing,
    required this.metaData,
    this.onAction,
    this.onCancel,
    required this.isSuccessful,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and tender type
            Row(
              children: [
                Text(
                  metaData.text,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: (ScreenUtil.height * 0.02).clamp(9, 12),
                    fontWeight: FontWeight.w900,
                    //fontFamily: 'Gilroy',
                  ),
                ),
                Container(
                  height: 12,
                  width: 0.8,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  color: AppColors.primaryColor,
                ),
                Text(
                  metaData.paymentType.description,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: (ScreenUtil.height * 0.02).clamp(9, 12),
                    fontWeight: FontWeight.w200,
                   // fontFamily: 'Gilroy',
                  ),
                ),
              ],
            ),

            SizedBox(
              width: double.infinity,
              child: Divider(thickness: 1.5, color: AppColors.secondaryColor),
            ),

            SizedBox(height: ConstantUtil.verticalSpacing),

            // Processing content area
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: ConstantUtil.verticalSpacing,
                  horizontal: ConstantUtil.horizontalSpacing,
                ),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(AppDrawables.progressCard),
                    fit: BoxFit.fill,
                  ),
                ),
                child: child,
              ),
            ),

            SizedBox(height: ConstantUtil.verticalSpacing),

            InlineText(title: AppStrings.selectAnAction),

            SizedBox(height: ConstantUtil.verticalSpacing),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: Btn(
                    isActive:isSuccessful?false: !isProcessing ,
                    bgImage: AppDrawables.redCard,
                    text: AppStrings.cancel,
                    onTap: onCancel ?? () {

                    },
                  ),
                ),
                SizedBox(width: ConstantUtil.horizontalSpacing),
                Expanded(
                  child: Btn(
                    isActive: !isProcessing,
                    bgImage: AppDrawables.greenCard,
                    text: AppStrings.done,
                    onTap: onAction ?? () {

                    },
                  ),
                ),
              ],
            ),
          ],
        ),

    );
  }
}