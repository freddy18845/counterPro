import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
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

  @override
  void initState() {
    super.initState();
    checkAuto();

    if (Platform.isWindows) {
      windowManager.addListener(this);
      _checkWindowStates();
    }
  }

  Future<void> checkAuto() async {
    final value = await ApiConfig.isSyncEnabled();
    if (mounted) {
      setState(() => syncEnabled = value);
    }
  }

  Future<void> _checkWindowStates() async {
    if (!Platform.isWindows) return;
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
    if (Platform.isWindows) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  // Window Listener Callbacks (Windows only)
  @override
  void onWindowMinimize() => _updateWindowState(minimized: true);
  @override
  void onWindowRestore() => _updateWindowState(minimized: false);
  @override
  void onWindowMaximize() => _updateWindowState(maximized: true);
  @override
  void onWindowUnmaximize() => _updateWindowState(maximized: false);

  void _updateWindowState({bool? minimized, bool? maximized}) {
    if (mounted) {
      setState(() {
        if (minimized != null) _isMinimized = minimized;
        if (maximized != null) _isMaximized = maximized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop = sizingInformation.deviceScreenType == DeviceScreenType.desktop ;
        final isTablet = sizingInformation.deviceScreenType == DeviceScreenType.tablet;
        final isMobile = sizingInformation.deviceScreenType == DeviceScreenType.mobile;

        return PopScope(
          canPop: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: isDesktop ? CustomHeaderBar() : null,
            bottomNavigationBar: isMobile ? const BranchInfo() : null,
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
                        top: isDesktop ? ConstantUtil.verticalSpacing : 12,
                        left: isDesktop ? ConstantUtil.horizontalSpacing : 8,
                        right: isDesktop ? ConstantUtil.horizontalSpacing : 8,
                      ),
                      child: Column(
                        children: [
                          // Top spacing
                          SizedBox(height: isDesktop ? 60 : (isTablet ? 40 : 20)),

                          // Summary Data
                          SummaryData(
                            syncEnabled: syncEnabled,
                            isProcessing: widget.isProcessing,
                            isHomeScreen: widget.isHomeScreen,
                            onSyncChanged: (value) async {
                              setState(() => syncEnabled = value);
                              await ApiConfig.setSyncEnabled(value);
                            },
                          ),

                          const SizedBox(height: 12),

                          // Main Content Area
                          Expanded(
                            child: widget.contentSection,
                          ),

                          // Show BranchInfo at bottom for tablet & desktop if needed
                          if (!isMobile) const BranchInfo(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}