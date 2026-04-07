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
    this.titleSize = 14,
    this.cardHeight = 300,
    this.cardWidth = 400,
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
          insetPadding: EdgeInsets.zero,
          child: MediaQuery.removeViewInsets(
            context: context,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: ConstantUtil.horizontalSpacing,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey, width: 3),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: LayoutBuilder(
                          builder: (_, dimens) => Padding(
                            padding: EdgeInsets.all(0),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        vertical:
                                            ConstantUtil.verticalSpacing / 3,
                                      ),

                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(height: 20, width: 20),
                                          Text(
                                            title,
                                            style: AppTheme.textStyle.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: titleSize,
                                            ),
                                          ),

                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    child,
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
            ),
          ),
        ),
      ],
    );
  }
}
