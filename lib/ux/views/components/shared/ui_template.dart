import 'dart:io';
import 'dart:ui';

import 'package:eswaini_destop_app/ux/utils/sessionManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../platform/utils/constant.dart';
import '../../../res/app_drawables.dart';
import '../../../utils/shared/api_config.dart';
import '../../../utils/shared/screen.dart';
import '../../../utils/shared/stock_monitor.dart';
import 'top_header.dart';
import 'branch_info.dart';
import 'summary_data.dart';

class BaseTemplate extends StatefulWidget {
  final bool isProcessing;
  final bool isHomeScreen;
  final Widget contentSection;
  const BaseTemplate({
    super.key,
    required this.contentSection,
    this.isProcessing = false,
    this.isHomeScreen = false,
  });

  @override
  State<BaseTemplate> createState() => _BaseTemplateState();
}

class _BaseTemplateState extends State<BaseTemplate> with WindowListener {
  bool _isMinimized = false;
  bool _isMaximized = false;
  bool syncEnabled = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    checkAuto();
    // Only add window listener on Windows platform
    if (Platform.isWindows) {
      windowManager.addListener(this);
      _checkWindowStates();
    }


    // Only set this after context exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use the global navigator key from main.dart
      // You need to import main.dart or access it through a global variable
      if (navigatorKey.currentContext != null) {
        StockMonitorService.setGlobalContext(navigatorKey.currentContext!);
      } else {
        // Fallback to the current context if navigatorKey is not available
        if (mounted) {
          StockMonitorService.setGlobalContext(context);
        }
      }
    });
  }
  Future<void> checkAuto() async {
    final value = await ApiConfig.isSyncEnabled();
    if (mounted) {
      setState(() {
        syncEnabled = value;
      });
    }
  }

  Future<void> _checkWindowStates() async {
    try {
      final isMinimized = await windowManager.isMinimized();
      final isMaximized = await windowManager.isMaximized();

      if (mounted) {
        setState(() {
          _isMinimized = isMinimized;
          _isMaximized = isMaximized;
        });
      }
    } catch (e) {
      print('Error checking window states: $e');
    }
  }

  @override
  void dispose() {
    // Only remove window listener on Windows platform
    if (Platform.isWindows) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  // WindowListener callbacks - only called on Windows
  @override
  void onWindowMinimize() {
    if (Platform.isWindows) {
      print('Window minimized - rebuilding UI');
      if (mounted) {
        setState(() {
          _isMinimized = true;
        });
      }
    }
  }

  @override
  void onWindowRestore() {
    if (Platform.isWindows) {
      print('Window restored - rebuilding UI');
      if (mounted) {
        setState(() {
          _isMinimized = false;
        });
      }
    }
  }

  @override
  void onWindowMaximize() {
    if (Platform.isWindows) {
      print('Window maximized - rebuilding UI');
      if (mounted) {
        setState(() {
          _isMaximized = true;
        });
      }
    }
  }



  @override
  void onWindowUnmaximize() {
    if (Platform.isWindows) {
      print('Window unmaximized - rebuilding UI');
      if (mounted) {
        setState(() {
          _isMaximized = false;
        });
      }
    }
  }

  @override
  void onWindowFocus() {
    if (Platform.isWindows) {
      print('Window focused');
      // Optional: Trigger rebuild when window gets focus
      if (mounted) {
        setState(() {
          // Force rebuild on focus if needed
        });
      }
    }
  }

  @override
  void onWindowBlur() {
    if (Platform.isWindows) {
      print('Window lost focus');
      // Optional: Handle blur if needed
    }
  }

  @override
  void onWindowClose() async {
    if (Platform.isWindows) {
      print('Window closing');
      // Handle window close - you might want to show a confirmation dialog
      // await windowManager.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug: Print current window state on build (Windows only)
    if (Platform.isWindows) {
      print('Building BaseTemplate - Minimized: $_isMinimized, Maximized: $_isMaximized');
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: ScreenUtil.width >= 900 ? CustomHeaderBar() : null,
        bottomNavigationBar: const BranchInfo(),
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
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.only(
                    top: ConstantUtil.verticalSpacing,
                    left: ConstantUtil.horizontalSpacing,
                    right: ConstantUtil.horizontalSpacing,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: ScreenUtil.width >= 900 ? 60 : 8),
                      SummaryData(
                        syncEnabled: syncEnabled,
                        isProcessing: widget.isProcessing,
                        isHomeScreen: widget.isHomeScreen,
                        onSyncChanged: (value) async {
                          setState(() {
                            syncEnabled = value;
                          });

                          await ApiConfig.setSyncEnabled(value);
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil.height * 0.76,
                        child: widget.contentSection,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}