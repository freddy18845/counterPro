import 'dart:async';
import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:eswaini_destop_app/ux/utils/shared/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isar/isar.dart';
import '../../../../platform/utils/constant.dart';
import '../../../models/shared/transaction.dart';
import '../../../res/app_drawables.dart';
import '../../../res/app_theme.dart';
import '../../../utils/sessionManager.dart';
import '../../../utils/shared/api_config.dart';
import '../../fragements/configSetting/sync_service.dart';
import '../../fragements/shared/text_styles.dart';
import '../dialogs/add_and_edit_users.dart';
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
final sessionManager = SessionManager();
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

  Future<void> _handleLogout() async {
    if (isProcessing) {
      AppUtil.toastMessage(
        context: context,
        message: AppStrings.processingPleaseWait,
      );
      return;
    }
    // final isar = Isar.getInstance();
    // await isar?.writeTxn(() async {
    //   await isar.clear();
    // });
  bool  syncEnabled = await ApiConfig.isSyncEnabled();
    if(syncEnabled){
      SyncService().syncAll(pushLocal: true, pullRemote: false, context: context);
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
    return  Container(
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
                  /// // display logo
                  // if (SessionManager().companyLogoPath != null) {
                  //   Image.file(File(SessionManager().companyLogoPath!));
                  // }
                  InkWell(
                    onTap: () {
                      if (isProcessing) {
                        AppUtil.toastMessage(
                          context: context,
                          message: AppStrings.processingPleaseWait,
                        );
                        return;
                      }
                      AppNavigator.gotoHome(TransactionData(),context: context);
                    },
                    child: Container(
                      height: double.maxFinite,
                      width: ScreenUtil.width * 0.15,
                      constraints: BoxConstraints(
                        maxWidth: ConstantUtil.maxWidthBtnAppBar,
                      ),
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: 10,
                        left: (ScreenUtil.width * 0.01).clamp(13, 15),
                        right: (ScreenUtil.width * 0.03).clamp(40, 60),
                      ),
                      margin: EdgeInsets.only(right: ScreenUtil.width * 0.03,),
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
                          InkWell(
                            onTap: () {
                              // Prevent crash if user not loaded yet
                              if (sessionManager.currentUser == null) {
                                AppUtil.toastMessage(
                                  context: context,
                                  message: "User not loaded yet",
                                );
                                return;
                              }

                              AppUtil.displayDialog(
                                dismissible: false,
                                context: context,
                                child: AddEditUsersDialog(
                                  user: sessionManager.currentUser,
                                ),
                              );
                            },
                            child: iconTitleAndText(
                              icon: AppDrawables.profileSVG,
                              title:
                              "${sessionManager.userRole?.name.toUpperCase() ?? 'ROLE'}",
                              text:
                              ": ${sessionManager.currentUser?.name ?? 'Loading...'}",
                            ),
                          )
                          ,
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


  }



  /// HELPER WIDGET - Icon with Title and Text

}