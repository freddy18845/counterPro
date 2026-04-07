import 'dart:io';
import 'dart:ui';
import 'package:eswaini_destop_app/platform/utils/isar_manager.dart';
import 'package:eswaini_destop_app/ux/blocs/screens/splash/bloc.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:eswaini_destop_app/ux/utils/shared/stock_monitor.dart';
import 'package:eswaini_destop_app/ux/utils/shared/subscriptionManger.dart';
import 'package:eswaini_destop_app/ux/utils/shared/tax_manager.dart';
import 'package:eswaini_destop_app/ux/views/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';



final locator = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSize = 50;
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      20 * 1024 * 1024;

  if(Platform.isWindows){
    // Must add this line
    await windowManager.ensureInitialized();
    Display primaryDisplay = await screenRetriever.getPrimaryDisplay();

    // 2. Grab the full size of the hardware screen
    Size screenSize = primaryDisplay.size;
    WindowOptions windowOptions = WindowOptions(
      size: screenSize,          // Set to the detected screen width/height
      center: true,
      fullScreen: false,         // Set to true if you want to hide the dock/taskbar
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.maximize();
    });
  }


  try {

    await IsarService().init();
    await StockMonitorService.init();
    await TaxManager().load();
   // await SubscriptionManager().load();
    StockMonitorService.startMonitoring();
    print("✅ Stock monitor initialized");
  } catch (e, stacktrace) {

    print("❌ Stock monitor init failed: $e");
    print(stacktrace);
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);
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

      home:
      BlocProvider(
        create: (context) => SplashBloc(),
        child: const SplashScreen(),
      ),
    );
  }
}


// git remote set-url origin https://github.com/freddy18845/counterPro.git

// git push -u origin main