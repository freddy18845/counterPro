import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../utils/shared/screen.dart';


class leftCardSection extends StatefulWidget {
  final Widget sideChild;
  const leftCardSection({super.key, required this.sideChild});

  @override
  State<leftCardSection> createState() => _leftCardSectionState();
}

class _leftCardSectionState extends State<leftCardSection> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (ScreenUtil.width * 0.25).clamp(320, 420),
      padding: EdgeInsets.symmetric(
        vertical: ConstantUtil.verticalSpacing,
        horizontal: ConstantUtil.horizontalSpacing,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardOutlineColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child:widget.sideChild ,
    );
  }
}