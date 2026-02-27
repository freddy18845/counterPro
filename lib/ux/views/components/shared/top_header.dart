import 'dart:async';
import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:eswaini_destop_app/ux/utils/shared/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../platform/utils/constant.dart';
import '../../../blocs/shared/processing/bloc.dart';
import '../../../res/app_drawables.dart';
import '../../../res/app_theme.dart';
import '../../fragements/shared/text_styles.dart';
import '../dialogs/logout.dart';

class CustomHeaderBar extends StatefulWidget implements PreferredSizeWidget {

  const CustomHeaderBar({super.key,});

  @override
  State<CustomHeaderBar> createState() => _CustomHeaderBarState();

  @override
  Size get preferredSize => const Size.fromHeight(ConstantUtil.maxHeightAppBar);
}

class _CustomHeaderBarState extends State<CustomHeaderBar> {
  bool isProcessing = false;
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get time =>
      "${_now.hour.toString().padLeft(2, '0')}:"
          "${_now.minute.toString().padLeft(2, '0')}:"
          "${_now.second.toString().padLeft(2, '0')}";

  String get date =>
      "${_now.day.toString().padLeft(2, '0')}-"
          "${AppTheme.monthName(_now.month)}-"
          "${_now.year}";

  void _handleLogout() {
    if (isProcessing) {
      AppUtil.toastMessage(
        context: context,
        message: AppStrings.processingPleaseWait,
      );
      return;
    }
     AppUtil.displayDialog(
      dismissible: false,
      context: context,
      child: LogoutDialog(),
    );
    // Add your logout logic here

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProcessingBloc, ProcessingState>(
      listener: (context, state) {
        if (state is ProcessingLoadingState) {
          setState(() {
            isProcessing = true;
          });
        }

        if (state is ProcessingSuccessState) {
          setState(() {
            isProcessing = false;
          });
          // Optional: Show success message
          // AppUtil.toastMessage(message: 'Transaction successful!');
        }

        if (state is ProcessingErrorState) {
          setState(() {
            isProcessing = false;
          });
          // Show error message
          AppUtil.toastMessage(message: state.message ?? 'An error occurred', context: context);
        }

        if (state is ProcessingInitialState) {
          setState(() {
            isProcessing = false; // Changed from true to false
          });
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          width: double.infinity,
          child: Center(
            child: Container(
              color: const Color(0xFF282A2E),
              width: double.infinity,
              // constraints: BoxConstraints(
              //   maxWidth: ConstantUtil.maxWidthAllowed,
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// HOME BUTTON
                  InkWell(
                    onTap: () {
                      if (isProcessing) {
                        AppUtil.toastMessage(
                          context: context,
                          message: AppStrings.processingPleaseWait,
                        );
                        return;
                      }
                      AppNavigator.gotoHome(context: context);
                    },
                    child: Container(
                      height: double.maxFinite,
                      width: ScreenUtil.width * 0.15,
                      constraints: BoxConstraints(
                        maxWidth: ConstantUtil.maxWidthBtnAppBar,
                      ),
                      padding: EdgeInsets.only(
                        top: 6,
                        bottom: 6,
                        left: (ScreenUtil.width * 0.01).clamp(13, 15),
                        right: (ScreenUtil.width * 0.03).clamp(40, 60),
                      ),
                      margin: EdgeInsets.only(right: ScreenUtil.width * 0.03),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppDrawables.greyCard),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: SvgPicture.asset(
                        AppDrawables.darkLogoSVG,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  /// CENTER (TIME & DATE)
                  Expanded(
                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 73,
                            child: iconText(
                              icon: AppDrawables.timeSVG,
                              title: time,
                            ),
                          ),
                          Spacer(),
                          iconText(
                            icon: AppDrawables.dateSVG,
                            title: date,
                          ),
                          Spacer(),
                          iconTitleAndText(
                            icon: AppDrawables.profileSVG,
                            title: AppStrings.teller,
                            text: 'SV2458685ESB',
                          ),
                          Spacer(),
                          iconTitleAndText(
                            icon: AppDrawables.globeSVG,
                            title: AppStrings.lang,
                            text: AppStrings.english,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// LOGOUT BUTTON
                  InkWell(
                    onTap: _handleLogout,
                    child: Container(
                      height: double.maxFinite,
                      width: ScreenUtil.width * 0.15,
                      constraints: BoxConstraints(
                        maxWidth: ConstantUtil.maxWidthBtnAppBar,
                      ),
                      padding: EdgeInsets.only(
                        left: (ScreenUtil.width * 0.08).clamp(80, 100),
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppDrawables.orangeCard),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: iconText(
                        icon: AppDrawables.logoutSVG,
                        title: AppStrings.logout,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  /// HELPER WIDGET - Icon with Title and Text

}