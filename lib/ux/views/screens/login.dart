import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:isar/isar.dart";
import "../../../platform/utils/isar_manager.dart";
import "../../blocs/screens/login/bloc.dart";
import "../../models/shared/pos_user.dart";
import "../../nav/app_navigator.dart";
import "../../res/app_drawables.dart";
import "../../res/app_strings.dart";
import "../../utils/shared/screen.dart";
import "../components/screens/login/password_section.dart";
import "../components/shared/footer.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc loginBloc;
  bool isLoading = false;
  bool obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final isar = IsarService().isar;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    loginBloc = context.read<LoginBloc>();
    loginBloc.init(context: context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginBloc.add(LoginInitEvent());
    });
    super.initState();
  }

  @override
  void dispose() {
    try {
      loginBloc.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: supportInfo(),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppDrawables.loadingScreen),
              fit: BoxFit.fill,
            ),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3.0,
                sigmaY: 3.0,
              ), // Adjust blur intensity here
              child: Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(
                  0.1,
                ), // Optional: adds a slight tint to the blur
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(padding: EdgeInsets.only(
                          top: ScreenUtil.height * 0.06,
                          right: ScreenUtil.width * 0.05
                      ),
                      child:Container(
                        height:  ScreenUtil.height * 0.06,
                        width:  ScreenUtil.height * 0.06,
                        decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(ScreenUtil.height * 0.06)
                        ),
                        alignment: Alignment.center,
                        child:  IconButton(
                          onPressed: () {
                            SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
                          },
                          icon: Icon(
                            Icons.power_settings_new_rounded,
                            size:  ScreenUtil.height * 0.03,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      ),
                    ),
                    ScreenUtil.width >=900? Spacer(): SizedBox(height:16 ,),

                    BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, LoginState state) {
                          Widget section = Container();

                          if (state is LoginPasswordState) {
                            section = LoginPasswordSection(
                              key: UniqueKey(),
                              isLoading: isLoading,
                              loginBloc: loginBloc,
                              emailController: emailController,
                              passwordController: passwordController,
                              subText: AppStrings.enterYourCredentialsToLogIn,
                              onSetValue: (String value) => loginBloc.add(
                                LoginSetPasswordEvent(value: value),
                              ),
                            );
                          }

                          return section;
                        },
                      ),

                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),

    );
  }
}
