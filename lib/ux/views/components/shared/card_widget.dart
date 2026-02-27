import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../platform/utils/constant.dart';
import '../../../res/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  const CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: ConstantUtil.verticalSpacing,
          horizontal: ConstantUtil.horizontalSpacing,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardOutlineColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
            padding: EdgeInsets.symmetric(
              vertical: ConstantUtil.verticalSpacing,
              horizontal: ConstantUtil.horizontalSpacing,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1.5, color: Colors.white),
            ),
            child: child,
        ))
            ;
  }
}
