import 'package:eswaini_destop_app/ux/res/app_drawables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../res/app_strings.dart';
import '../../../utils/shared/screen.dart';

class supportInfo extends StatelessWidget {
  const supportInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: null,
                icon: SvgPicture.asset(AppDrawables.phoneSVG,height: 10, color: Colors.white,),
                label: Text(
                  AppStrings.supportPhone,
                  style: TextStyle(
                    fontSize: (ScreenUtil.height * 0.02).clamp(10, 11),
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                    // fontStyle: FontStyle.italic,
                  ),
                ),
              ),
             SizedBox(
               height: 12,
               child:  VerticalDivider(thickness: 1,color: Colors.white54 ,),),
              TextButton.icon(
                onPressed: null,
                icon: SvgPicture.asset(AppDrawables.whatsappSVG,height: 10, color: Colors.white,),
                label: Text(
                  AppStrings.supportWhatsappLine,
                  style: TextStyle(
                    fontSize: (ScreenUtil.height * 0.02).clamp(10, 11),
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                    // fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],),
          Text(
            "${AppStrings.anAppBySvn}",
            style: TextStyle(
              fontSize: (ScreenUtil.height * 0.02).clamp(10, 11),
              color: Colors.white54,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
              fontStyle: FontStyle.italic,
            ),
          ),
          TextButton.icon(
            onPressed: null,
            icon: SvgPicture.asset(AppDrawables.globeSVG,height: 10,),
            label: Text(
              AppStrings.link,
              style: TextStyle(
                fontSize: (ScreenUtil.height * 0.02).clamp(10, 12),
                color: Colors.white54,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
