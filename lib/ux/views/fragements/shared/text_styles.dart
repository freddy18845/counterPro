import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res/app_theme.dart';
import '../../../utils/shared/screen.dart';

Widget iconText({required String icon, required String title}) {
  return Row(
    children: [
      SvgPicture.asset(icon, height: 14, fit: BoxFit.fill),
      SizedBox(width: 6),
      Text(
          title,
          style:AppTheme.getTextStyle(bold: true,size: (ScreenUtil.height * 0.02).clamp(9, 12))
      ),
    ],
  );
}

Widget iconTitleAndText({required String icon, required String title,required  String text}) {
  return Row(
    children: [
  RepaintBoundary(
  child:  SvgPicture.asset(icon, height: 14, fit: BoxFit.fill),),

      const SizedBox(width: 6),
      Text(title, style: AppTheme.getTextStyle(bold: true,size: (ScreenUtil.height * 0.02).clamp(9, 12))),
      const SizedBox(width: 2),
      Text(text, style: AppTheme.getTextStyle(size: (ScreenUtil.height * 0.02).clamp(9, 12))),
    ],
  );
}
