import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../platform/utils/constant.dart';
import '../../../res/app_drawables.dart';
import '../../../utils/shared/screen.dart';

class Btn extends StatelessWidget {
  final String text;
  final String bgImage;
  final VoidCallback onTap;
  final bool isActive;
  final double btnHeight;

  const Btn({
    super.key,
    required this.text,
    required this.onTap,
    this.isActive = true,
     this.bgImage = AppDrawables.blueCard,
     this.btnHeight = ConstantUtil.maxHeightBtn,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ScreenUtil.width >= 900;
    return  InkWell(
        onTap: isActive ? onTap : null,
        child:Container(
          width: double.infinity,
          height:isDesktop ?btnHeight:(btnHeight-10) ,
          decoration: BoxDecoration(
            image:  DecorationImage(
              image: AssetImage(bgImage),
              fit: BoxFit.fill,
              opacity: isActive ? 1.0 : 0.5,
            ),
            border: Border.all(
              width: 1.0,
              color:  Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: (ScreenUtil.height * 0.02).clamp(9, 12),
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: 'Gilroy',
            ),
          ),
        ),

    );
  }
}


class ColorBtn extends StatefulWidget {
  final String text;
  final Color btnColor;
  final VoidCallback action;
  const ColorBtn({super.key, required this.text, required this.btnColor, required this.action});

  @override
  State<ColorBtn> createState() => _ColorBtnState();
}

class _ColorBtnState extends State<ColorBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.action();
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:widget.btnColor,
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: (ScreenUtil.height * 0.02).clamp(10, 12),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
