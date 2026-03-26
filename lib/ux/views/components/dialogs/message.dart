import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:eswaini_destop_app/ux/nav/app_navigator.dart";
import "package:flutter/material.dart";
import "../../../res/app_colors.dart";
import "../../../res/app_strings.dart";
import "../../../res/app_theme.dart";
import "../../../utils/sessionManager.dart";
import "../../../utils/shared/screen.dart";
import "../shared/base_dailog.dart";

class MessageDialog extends StatefulWidget {
  final String title;
  final String message;
  const MessageDialog({super.key, required this.title, required this.message});

  @override
  State<MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DialogBaseLayout(
        title:widget. title,
        titleSize: 20,
        showCard: true,
        onClose: () {
          Navigator.pop(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: ConstantUtil.verticalSpacing,
              ),

              child: Center(
                child: Text(
                widget.message,
                  style: AppTheme.textStyle.copyWith(
                    color:Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: (ScreenUtil.width * 0.035).clamp(12, 14),
                  ),
                ),
              ),
            ),

            // Buttons row
            Container(
              width: (ScreenUtil.width * 0.02).clamp(400, 520),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                spacing: 12,
                children: [
                  // Cancel Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          AppStrings.no,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Proceed Button
                  Expanded(
                    child: AnimatedOpacity(
                      opacity:  1.0 ,
                      duration: Duration(milliseconds: 300),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context,true);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.green,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.yes,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
