import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/shared/screen.dart';

class HomeUpperCard extends StatefulWidget {

  const HomeUpperCard({super.key});

  @override
  State<HomeUpperCard> createState() => _HomeUpperCardState();
}

class _HomeUpperCardState extends State<HomeUpperCard> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      //height: ScreenUtil.height * 0.3,
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil.height * 0.03,
          horizontal: ScreenUtil.width * 0.015
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        // Use .only for specific corner control
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryColor.withValues(alpha: 0.02),
          border: Border.all(width: 1.0 ,color:Colors.grey.withValues(alpha: 0.1) ),
          // Use .only for specific corner control
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(AppStrings.home),
              Text(AppStrings.welcomeToANewPaymentExperience)
          ],)
        ],),
      ),
    );
  }
}
