
import "dart:ui";

import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:eswaini_destop_app/ux/res/app_colors.dart";
import "package:flutter/material.dart";
import "../../../res/app_strings.dart";
import "../../../res/app_theme.dart";
import "../../../utils/shared/screen.dart";

class DialogBaseLayout extends StatelessWidget {

  final String title;
  final bool showCard;
  final void Function()? onClose;
  final Widget child;
  final double? topPadding;
  final double? cardHeight;
  final double? cardWidth;
  final double? titleSize;

  const DialogBaseLayout({
    super.key,
    required this.title,
    this.showCard = false,
    this.topPadding,
    this.onClose,
    this.titleSize=14,
    this.cardHeight=300,
    this.cardWidth=400,
    required this.child,
  });


  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
    /// 🔹 Blur Background
    BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
    child: Container(
    color: Colors.black.withOpacity(0.3), // optional dark overlay
    ),
    ),



      Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:EdgeInsets.zero ,
      child: MediaQuery.removeViewInsets(
        context: context,
        child:Container(
          width: showCard? cardWidth:double.maxFinite,
          height: showCard?cardHeight:double.maxFinite ,
          padding: EdgeInsets.symmetric(
            vertical: showCard? 12:0,
            horizontal: showCard?ConstantUtil.horizontalSpacing:0,
          ),
          decoration:   showCard? BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 3)
          ):BoxDecoration(
          //  color: AppColors.t,
          ),
            child:  Stack(
        children: [
        Align(
        alignment: Alignment.center,
          child:  Material(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (_, dimens) => Padding(
                    padding: EdgeInsets.all (0),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: ConstantUtil.verticalSpacing/3,
                              ),

                              child: Center(
                                child: Text(
                                  title,
                                  style: AppTheme.textStyle.copyWith(
                                    color:!showCard ?Colors.white:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: titleSize,
                                  ),
                                ),
                              ),
                            ),
                            child,

                            !showCard? InkWell(
                              onTap: () {Navigator.pop(context);},
                              child: Container(
                                width: (ScreenUtil.width * 0.02).clamp(400, 520),
                                margin: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    AppStrings.cancel,
                                    style: AppTheme.textStyle.copyWith(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: (ScreenUtil.width * 0.035).clamp(10, 12),
                                    ),
                                  ),
                                ),
                              ),):SizedBox()
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),

          ),
        ),
        ],
      ),
        )

       ,
      ),
    )
      ],
    );}

}
