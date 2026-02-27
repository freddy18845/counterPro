import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../blocs/screens/login/bloc.dart";
import "../../enums/screens/login/flow_step.dart";
import "../../res/app_drawables.dart";
import "../../res/app_strings.dart";
import "../../utils/shared/screen.dart";
import "../components/screens/login/password_section.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc loginBloc;

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
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppDrawables.loadingScreen),
              fit: BoxFit.fill,
            ),
          ),
          child:ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), // Adjust blur intensity here
              child: Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.1), // Optional: adds a slight tint to the blur
                child: Column(

            children: [
             // CustomHeaderBar(),
              SizedBox(height:
                  ScreenUtil.height * 0.23
              ),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, LoginState state) {
                  Widget section = Container();

                  if (state is LoginPasswordState) {
                    loginBloc.activeStep = LoginFlowStep.password;
                    section = LoginPasswordSection(
                      key: UniqueKey(),
                      loginBloc: loginBloc,
                      subText: AppStrings.enterYourCredentialsToLogIn,
                      onSetValue: (String value) =>
                          loginBloc.add(LoginSetPasswordEvent(value: value)),
                      onSubmit: () => loginBloc.add(LoginSubmitPasswordEvent()),
                    );
                  }
                  // if (state is LoginSubmitPasswordState) {
                  //   loginBloc.activeStep = LoginFlowStep.checkPassword;
                  //   section = LoginPasswordProgressSection(
                  //     key: UniqueKey(),
                  //     loginBloc: loginBloc,
                  //     isLoading: state.isLoading,
                  //     error: state.error,
                  //     onRetry: () => loginBloc.add(LoginSubmitPasswordEvent()),
                  //     onAction: () => loginBloc.add(LoginResetPasswordEvent()),
                  //   );
                  // }
                  // if (state is LoginGetTransactionsState) {
                  //   loginBloc.activeStep = LoginFlowStep.getTransactions;
                  //   section = LoginPasswordProgressSection(
                  //     key: UniqueKey(),
                  //     loginBloc: loginBloc,
                  //     isLoading: state.isLoading,
                  //     error: state.error,
                  //     progressText: AppStrings.gettingTransactions,
                  //     onRetry: () => loginBloc.add(LoginGetTransactionsEvent()),
                  //   );
                  // }
                  return section;
                },
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 30,
                ),
                child: Text(
                  AppStrings.link,
                  style: TextStyle(
                    fontSize: (ScreenUtil.height * 0.02).clamp(8, 10),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
            ]
          ),
        ),
            ),
          )) ));
  }
}
