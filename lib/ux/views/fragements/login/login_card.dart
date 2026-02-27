import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utils/shared/screen.dart';

class CardIcon extends StatefulWidget {
  final String svgIcon;
  final String text;
  final VoidCallback action;
  const CardIcon({super.key, required this.svgIcon, required this.text, required this.action});

  @override
  State<CardIcon> createState() => _CardIconState();
}

class _CardIconState extends State<CardIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.action,
      child: Container(
        width: double.infinity,
        height: ConstantUtil.maxOtpHeight,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          //border: Border.all(width: 1.0, color: activeColor),
        ),
        child: Row(
          children: [
            SvgPicture.asset(widget.svgIcon, height: 16, width: 14),
            SizedBox(width: 8,),
            Text(widget.text, style: TextStyle(
              fontSize: (ScreenUtil.height * 0.02).clamp(10, 12),
              fontWeight: FontWeight.normal,
              fontFamily: 'Gilroy',
            ),),
          ],
        ),
      ),
    );
  }
}
