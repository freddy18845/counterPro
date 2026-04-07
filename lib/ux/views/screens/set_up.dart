// lib/ux/views/screens/setup_choice.dart
import 'dart:ui';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/res/app_drawables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../platform/utils/constant.dart';
import '../../utils/shared/screen.dart';
import '../components/screens/setupScreen/existingBusinessAPIAccess.dart';
import '../components/screens/setupScreen/getStarted.dart';
import '../components/shared/footer.dart';

// ── Which setup mode ──────────────────────────────────────────
enum SetupMode { getStarted, existingBusiness }

class SetupChoiceScreen extends StatefulWidget {
  const SetupChoiceScreen({super.key});

  @override
  State<SetupChoiceScreen> createState() =>
      _SetupChoiceScreenState();
}

class _SetupChoiceScreenState extends State<SetupChoiceScreen> {
  SetupMode _mode = SetupMode.getStarted;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context: context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
     bottomNavigationBar:  setUpSupportInfo(),
      body:Container(
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
            filter: ImageFilter.blur(
              sigmaX: 3.0,
              sigmaY: 3.0,
            ),


    child:   Align(
      alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ConstantUtil.horizontalSpacing,
            vertical: ConstantUtil.verticalSpacing,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // ── Logo ────────────────────────────────────
          RepaintBoundary(
            child:  SvgPicture.asset(
                AppDrawables.logoSVG,
                width: 100,
                height: 40,
                fit: BoxFit.fitWidth,
              )),
              const SizedBox(height: 8),
              Text(
                'Your Number One Point of Sale Solution',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontFamily: 'Gilroy',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // ── Mode toggle ──────────────────────────────
              Container(
                padding:  EdgeInsets.all(4),
                margin:  EdgeInsets.symmetric(horizontal: ScreenUtil.width *0.25),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: SetupMode.values.map((mode) {
                    final isActive = _mode == mode;
                    final label = mode == SetupMode.getStarted
                        ? '🚀  Get Started'
                        : '🏢  Existing Business';

                    return Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _mode = mode),
                        child: RepaintBoundary(
                          child:AnimatedContainer(
                          duration:
                          const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isActive
                                  ? AppColors.primaryColor
                                  : Colors.white
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                        )),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // ── Content card ─────────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(
                        opacity: animation, child: child),
                child: _mode == SetupMode.getStarted
                    ? GetStartedCard(
                    key: const ValueKey('getStarted'))
                    : ExistingBusinessCard(
                    key: const ValueKey('existing')),
              ),
            ],
          ),
        ),
      ),
          ))) );
  }
}



