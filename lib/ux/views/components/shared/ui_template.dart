import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../platform/utils/constant.dart';
import '../../../res/app_drawables.dart';
import 'top_header.dart';
import '../screens/home/reciept_section.dart';
import 'branch_info.dart';
import 'exchange_rate.dart';

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
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: CustomHeaderBar(),
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
                  constraints: BoxConstraints(
                    maxWidth: ConstantUtil.maxWidthAllowed,
                    maxHeight:
                        ConstantUtil.maxHeightAllowed, // 10 inches at 96 DPI
                  ),
                  padding: EdgeInsets.only(
                    top: ConstantUtil.verticalSpacing*1.3,
                    left: ConstantUtil.horizontalSpacing,
                    right: ConstantUtil.horizontalSpacing
                  ),
                  child: Column(
                    children: [


                       ExchangeRate(isHomeScreen: widget.isHomeScreen,),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded( child: widget.contentSection),

                            SizedBox(width: ConstantUtil.horizontalSpacing),

                            // 3. Right Side: Receipt
                            const ReceiptSection(),
                          ],
                        ),
                      ),

                      // 4. Footer: Branch Info stays at the bottom
                      const BranchInfo(),
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
