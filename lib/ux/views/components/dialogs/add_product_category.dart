import "dart:async";

import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "../../../res/app_colors.dart";
import "../../../res/app_drawables.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/screen.dart";
import "../shared/base_dailog.dart";

class NameLookUpDialog extends StatefulWidget {
  const NameLookUpDialog({super.key});

  @override
  State<NameLookUpDialog> createState() => _NameLookUpDialogState();
}

class _NameLookUpDialogState extends State<NameLookUpDialog> {
  int? _selectedIndex;
  bool _isLoading = true;
  Timer? _timer;
  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DialogBaseLayout(
        title: AppStrings.accountNameLookUp,
        showCard: true,
        titleSize: 14,
        cardHeight:180 ,
        cardWidth:350 ,
        onClose: () {
          Navigator.pop(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 4),
            Container(
                width: (ScreenUtil.width * 0.2).clamp(295, 296), // Match your desired square size
                height:(ScreenUtil.height * 0.08).clamp(40, 45),
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 16,),
                decoration: BoxDecoration(
                    color:  Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isLoading? Text(
                 AppStrings.fetchingAccountName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ):Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.accountName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),),
                    Text(
                     "Frank k. Lowasa",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),)
                  ],
                  ),
                  _isLoading?   CupertinoActivityIndicator(radius: 12, color: Colors.grey):Image.asset(
                    AppDrawables.successImage,
                    color: AppColors.green,
                    fit: BoxFit.fill,
                    height: 30,
                    width: 30,
                  )


              ],),
              ),
            SizedBox(height: 4),
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
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          AppStrings.cancel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Proceed Button
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: !_isLoading ? 1.0 : 0.5,
                      duration: Duration(milliseconds: 300),
                      child: GestureDetector(
                        onTap: !_isLoading
                            ? () {
                          Navigator.pop(context, true);
                        }
                            : null,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: !_isLoading
                              ? AppColors.green
                                : AppColors.green.withValues(alpha: 0.3),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.confirm,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
