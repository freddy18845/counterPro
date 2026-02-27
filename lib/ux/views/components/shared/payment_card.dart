import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/models/screens/payment/payment_option.dart';
import 'package:eswaini_destop_app/ux/res/app_drawables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/shared/screen.dart';

class PaymentCard extends StatefulWidget {
  final PaymentOption item;
  final double width;
  final VoidCallback? onTap;

  const PaymentCard({
    super.key,
    required this.item,
    required this.width,
    this.onTap,
  });

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: SizedBox(
        width: widget.width,
        height: ConstantUtil.maxHeightBtn,
        child: GestureDetector(
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) {
            setState(() => isPressed = false);
            widget.onTap?.call();
          },
          onTapCancel: () => setState(() => isPressed = false),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3.5, horizontal: 20.5),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(AppDrawables.blueCard),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  widget.item.icon,
                  height: (ScreenUtil.height * 0.075).clamp(12.0, 24.0),
                  width: (ScreenUtil.height * 0.075).clamp(12.0, 24.0),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.item.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: (ScreenUtil.height * 0.02).clamp(9.0, 12.0),
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}