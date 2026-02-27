
import "package:flutter/material.dart";
import "../../../utils/shared/screen.dart";

class CurveAmountBase extends StatelessWidget {
  final Widget child;

  const CurveAmountBase({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: (ScreenUtil.height * 0.1).clamp(50, 90),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration:  BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        border: Border.all(width: 1.0, color:  Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(6)

      ),
      alignment: Alignment.center, // Ensures child is centered
      child: child,
    );
  }
}
