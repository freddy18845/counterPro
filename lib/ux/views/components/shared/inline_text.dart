import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../res/app_colors.dart';
import '../../../utils/shared/screen.dart';

class InlineText extends StatelessWidget {
  final String title;

  const InlineText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 2, color: AppColors.secondaryColor)),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: (ScreenUtil.height * 0.025).clamp(12, 14),
              fontWeight: FontWeight.bold,
              //fontFamily: 'Gilroy',
            ),
          ),
        ),
        Expanded(child: Divider(thickness: 2, color: AppColors.secondaryColor)),
      ],
    );
  }
}
