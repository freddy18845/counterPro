
import 'package:eswaini_destop_app/ux/blocs/screens/splash/bloc.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:eswaini_destop_app/ux/utils/api_client.dart';
import 'package:eswaini_destop_app/ux/views/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:window_manager/window_manager.dart';

import 'ux/utils/secure_storage.dart';


final locator = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();
   locator.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  locator.registerLazySingleton(() => ApiClient());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);
  final binding = WidgetsFlutterBinding.ensureInitialized();
  // WindowOptions windowOptions =  WindowOptions(
  //   size: Size(ConstantUtil.maxWidthAllowed, ConstantUtil.maxHeightAllowed), // Force 11-inch dimensions
  //   center: true,
  //   title: AppStrings.appName,
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });
  // // ✅ After first frame is scheduled, do precaching
  // WidgetsBinding.instance.addPostFrameCallback((_) async {
  //   final renderView = binding.renderViewElement;
  //   if (renderView != null) {
  //     await precacheAppImages(renderView); // your async precache function
  //   }
  //
  //   // ▶️ Now allow Flutter to paint the first frame
  //   binding.allowFirstFrame();
  // });

  /// 🔑 Precache before first frame

  runApp(const MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
        ),
        useMaterial3: true,
      ),

      /// 👇 Clamp text scaling globally
      builder: (context, child) {
        return MediaQuery.withClampedTextScaling(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.0,
          child: child!,
        );
      },

      home: BlocProvider(
        create: (context) => SplashBloc(),
        child: const SplashScreen(),
      ),
    );
  }
}

