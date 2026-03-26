import "package:flutter/cupertino.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../nav/app_navigator.dart";
import "../../../utils/setup_checker.dart";


part "event.dart";
part "state.dart";

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final String _tag = "SplashBloc";

  SplashBloc() : super(SplashLoadingState()) {
    on<SplashInitEvent>((event, emit) async {
      try {

        await Future.delayed(const Duration(milliseconds: 4000));

        final isDone = await SetupChecker.isSetupDone(event.context);

        if (!event.context.mounted) return;
        bool isSubscriptionValid =
            await SetupChecker.checkAndHandleSubscriptionStatus(event.context);
        if (isDone) {
        //  if (isSubscriptionValid) {
            AppNavigator.gotoLogin(context: event.context);
            return;
          // }else{
          //   emit(SplashErrorState(message: "Your subscription has expired.\n"
          //       "Please contact support or visit our website to renew."));
          // }
        } else {
          AppNavigator.gotoSetUp(context: event.context);
        }
      } catch (e) {
        print('❌ SplashBloc error: $e');
        emit(SplashErrorState(message: '$e'));
      }
    });
  }
}
