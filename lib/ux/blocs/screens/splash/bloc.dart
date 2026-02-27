
import "package:flutter/cupertino.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../../platform/utils/constant.dart";
import "../../../nav/app_navigator.dart";
import "../../../res/app_strings.dart";
import "../../../utils/api_client.dart";
import "../../../utils/debug_config.dart";


part "event.dart";
part "state.dart";

class SplashBloc extends Bloc<SplashEvent,SplashState> {

  final String _tag = "SplashBloc";

  SplashBloc() : super(SplashLoadingState()) {
    on<SplashInitEvent>((event,emit) async {
      DateTime nowTime = DateTime.now();


      //Initialize CardSDK
      if (!event.context.mounted) return;
      final config = await DebugConfigStorage.retrieveAppDebugConfig();
      if (config.useDebugBaseUrl) ConstantUtil.defaultUrl = config.baseUrl!;
      await ApiClient().initialize(config.useDebug);
      //DeviceManager().getSerialNumAndID();
     // DeviceManager().checkIfDeviceManufacturerIsInList();
      await Future.delayed(const Duration(milliseconds: 4000));
      if (!event.context.mounted) return;
      AppNavigator.gotoLogin(context: event.context);
    });
  }


}
