import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../res/app_drawables.dart';
import '../../../../utils/shared/screen.dart';
import '../../shared/carousel.dart';

class HomeUpperCard extends StatefulWidget {
  const HomeUpperCard({super.key});

  @override
  State<HomeUpperCard> createState() => _HomeUpperCardState();
}

class _HomeUpperCardState extends State<HomeUpperCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil.height * 0.03,
        horizontal: ScreenUtil.width * 0.015,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardOutlineColor,
          borderRadius: BorderRadius.circular(10)
        // Use .only for specific corner control
      ),
      child: Carousel()
          .animate()
// 1. Wait slightly so it appears after the initial screen load
          .fadeIn(delay: 300.ms, duration: 600.ms)
// 2. Gently slide down from the top (using slideY with a negative begin)
          .slideY(begin: -0.1, end: 0, curve: Curves.easeOutCubic)
// 3. Optional: add a slight blur-to-clear effect for a premium look
          .blur(begin: const Offset(10, 10), end: Offset.zero),
    );
  }
}
