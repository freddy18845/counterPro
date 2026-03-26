import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../platform/utils/constant.dart';
import '../../../res/app_drawables.dart';
import '../../../utils/shared/screen.dart';
import '../../../utils/shared/stock_monitor.dart';
import 'top_header.dart';
import 'branch_info.dart';
import 'summary_data.dart';

class BaseTemplate extends StatefulWidget {
  final bool isProcessing;
  final bool isHomeScreen;
  final Widget contentSection;
  const BaseTemplate({super.key,
    required this.contentSection,
    this.isProcessing=false,
    this.isHomeScreen=false,
    });

  @override
  State<BaseTemplate> createState() => _BaseTemplateState();
}

class _BaseTemplateState extends State<BaseTemplate> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  void initState() {
    super.initState();

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


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        extendBodyBehindAppBar: true,

        appBar:ScreenUtil.width >=900? CustomHeaderBar():null,
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
                    right: ConstantUtil.horizontalSpacing
                  ),
                  child: Column(
                    children: [
                      SizedBox(height:ScreenUtil.width >=900? 60:8),
                      SummaryData(
                        isProcessing: widget.isProcessing,
                        isHomeScreen: widget.isHomeScreen,),
                      SizedBox(
                        height: ScreenUtil.height * 0.76,
                        child: widget.contentSection

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
