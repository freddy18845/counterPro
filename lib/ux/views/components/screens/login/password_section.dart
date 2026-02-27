import "package:eswaini_destop_app/ux/nav/app_navigator.dart";
import "package:eswaini_destop_app/ux/res/app_strings.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_svg/svg.dart";
import "../../../../../platform/utils/constant.dart";
import "../../../../Providers/transaction_provider.dart";
import "../../../../blocs/screens/login/bloc.dart";
import "../../../../res/app_colors.dart";
import "../../../../res/app_drawables.dart";
import "../../../../res/app_theme.dart";
import "../../shared/btn.dart";
import "../../shared/login_input.dart";
import "../../shared/otp_field.dart";
import "../../../../utils/shared/screen.dart";
import "../../../fragements/login/login_card.dart";

class LoginPasswordSection extends StatelessWidget {
  final LoginBloc loginBloc;
  final String subText;
  final void Function(String value) onSetValue;
  final void Function() onSubmit;

  LoginPasswordSection({
    super.key,
    required this.loginBloc,
    required this.subText,
    required this.onSetValue,
    required this.onSubmit,
  });
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return
        Container(
          width: ConstantUtil.loginInputWidth,

          decoration:  BoxDecoration(
              color: AppColors.cardOutlineColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 5)
          ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Center(
            child: SvgPicture.asset(
              AppDrawables.darkLogoSVG,
              width: 150,
              height: 70,
              fit: BoxFit.fitWidth,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              subText,
              style: TextStyle(
                fontSize: (ScreenUtil.height * 0.02).clamp(10, 12),
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
          EmailInputField(controller: _emailController),
          SizedBox(height: 15),
          Container(

            width: ConstantUtil.loginInputWidth,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: OtpField(
              controller: loginBloc.fieldController,
              length: 6,
              secured: true,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: ConstantUtil.loginInputWidth,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            decoration:  BoxDecoration(
                color: AppColors.cardOutlineColor.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child:    ColorBtn(text: AppStrings.cancel, btnColor:  AppColors.red,action: (){},),),
              SizedBox(width: 24,),
              Expanded(child:   ColorBtn(text: AppStrings.login, btnColor:   AppColors.secondaryColor,action: (){
                AppNavigator.gotoHome(context: context);
              },))
            ],
          ),
          ),


        ],
      ),
    ).animate()
// 1. Wait slightly so it appears after the initial screen load
          .fadeIn(delay: 300.ms, duration: 600.ms)
// 2. Gently slide down from the top (using slideY with a negative begin)
          .slideY(begin: -0.1, end: 0, curve: Curves.easeOutCubic)
// 3. Optional: add a slight blur-to-clear effect for a premium look
          .blur(begin: const Offset(10, 10), end: Offset.zero);
  }
}
