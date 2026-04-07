import "package:flutter/cupertino.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../nav/app_navigator.dart";
import "../../../utils/setup_checker.dart";
import "../../../utils/shared/api_config.dart";
import "../../../utils/shared/subscriptionManger.dart";
import "../../../views/fragements/configSetting/sync_service.dart";


part "event.dart";
part "state.dart";

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final String _tag = "SplashBloc";

  SplashBloc() : super(SplashLoadingState()) {
    on<SplashInitEvent>((event, emit) async {
      try {

        await Future.delayed(const Duration(milliseconds: 4000));

        _checkAndRoute(event.context);
      } catch (e) {
        print('❌ SplashBloc error: $e');
        emit(SplashErrorState(message: '$e'));
      }
    });
  }


  // in your splash init handler
  Future<void> _checkAndRoute(BuildContext context) async {
    final isSetupDone = await SetupChecker.isSetupDone();

    if (!isSetupDone) {
      // ← go to choice screen not setup directly
      AppNavigator.gotoSetUp(context: context);
      return;
    }
    // final subResult = await SubscriptionManager.checkSubscription();
    //
    // if (subResult.isExpired) {
    //   // ← subscription expired — show blocking screen
    //   if (context.mounted) {
    //     AppNavigator.gotoSubscriptionExpired(
    //       context: context,
    //       result:  subResult,
    //     );
    //   }
    //   return;
    // }
    // setup done — check if sync needed on startup
    final syncEnabled = await ApiConfig.isSyncEnabled();
    if (syncEnabled) {
      SyncService().syncAll(
        pushLocal: true,
        pullRemote: true,
        context: context

      ).then((r) {
        debugPrint(
          '🔄 Startup sync: '
              'pushed=${r.pushed} pulled=${r.pulled}',
        );
      });
    }
    AppNavigator.gotoLogin(context: context);
  }
}
