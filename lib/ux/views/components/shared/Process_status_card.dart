import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/models/screens/payment/payment_option.dart';
import 'package:eswaini_destop_app/ux/res/app_drawables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_strings.dart';
import '../../../utils/shared/screen.dart';

class ProcessingStatusCard extends StatefulWidget {
  final String title;
  final bool isProcessing;

  const ProcessingStatusCard({
    super.key,
    required this.title,
    required this.isProcessing,
  });

  @override
  State<ProcessingStatusCard> createState() => _ProcessingStatusCardState();
}

class _ProcessingStatusCardState extends State<ProcessingStatusCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      // ← Fixed: Was "Expand"
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: ConstantUtil.verticalSpacing*2),
          Text(
            AppStrings.transactionInProgress,
            style: TextStyle(
              color: widget.isProcessing
                  ? AppColors.primaryColor
                  : AppColors.green,
              fontSize: (ScreenUtil.height * 0.02).clamp(10, 14),
              fontWeight: FontWeight.bold,
             // fontFamily: 'Gilroy',
            ),
          ),
          SizedBox(height: ConstantUtil.verticalSpacing / 2),
          Text(
            AppStrings.pleaseWait,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: (ScreenUtil.height * 0.02).clamp(10, 12),
              fontWeight: FontWeight.w500,
            //  fontFamily: 'Gilroy',
            ),
          ),
          Spacer(),
          widget.isProcessing
              ?  Image.asset(
                    AppDrawables.greenLoadingGif,
                    fit: BoxFit.fill,
                    height: (ScreenUtil.height * 0.02).clamp(100, 120),
                    width: (ScreenUtil.height * 0.02).clamp(100, 120),
                  )

              : Image.asset(
                  AppDrawables.successImage,
                  color: AppColors.green,
                  fit: BoxFit.fill,
            height: (ScreenUtil.height * 0.02).clamp(100, 120),
            width: (ScreenUtil.height * 0.02).clamp(100, 120),
                ),
          Spacer(),
          // Container(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: ConstantUtil.horizontalSpacing * 4,
          //   ),
          //   width: double.infinity,
          //   child: Divider(thickness: 0.7, color: Colors.grey),
          // ),
          SizedBox(height: ConstantUtil.verticalSpacing / 4),
          // widget.data.label == AppStrings.card
          //
          //     ? Container(
          //   padding: EdgeInsets.only(bottom: ConstantUtil.verticalSpacing*2),
          //   child:  Image.asset(
          //     AppDrawables.visaImage,
          //     // Remove fit: BoxFit.fitHeight if you want strict height/width control
          //     height: (ScreenUtil.height * 0.15).clamp(20, 25),
          //     width: (ScreenUtil.width * 0.25).clamp(120, 140),
          //     fit: BoxFit.fill,
          //   ),
          // )
          //     : Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           widget.data.label == AppStrings.wallet?   Container(
          //             height: (ScreenUtil.height * 0.075).clamp(12, 24),
          //             width: (ScreenUtil.height * 0.075).clamp(12, 24),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(8),
          //               border: Border.all(width: 1, color: widget.data.walletPayment.outLineColor),
          //               image: DecorationImage(
          //                 fit: BoxFit.contain, // Contain keeps the logo from touching edges
          //                 image: AssetImage(
          //                 widget.data.walletPayment.image),
          //              ),
          //             ),
          //           ): Container(
          //             height: (ScreenUtil.height * 0.075).clamp(12, 24),
          //             width: (ScreenUtil.height * 0.075).clamp(12, 24),
          //             padding: EdgeInsets.all(2),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(8),
          //               border: Border.all(width: 1, color: widget.data.walletPayment.outLineColor),
          //
          //             ),
          //             child: SvgPicture.asset(widget.data.icon),
          //           )
          //           ,
          //           Container(
          //             height: 12,
          //             width: 0.8,
          //             margin: EdgeInsets.symmetric(horizontal: 8),
          //             color: AppColors.primaryColor,
          //           ),
          //           Text(
          //             widget.data.description,
          //             overflow: TextOverflow.ellipsis,
          //             style: TextStyle(
          //               fontSize: (ScreenUtil.height * 0.02).clamp(9, 12),
          //               fontWeight: FontWeight.w900,
          //             //  fontFamily: 'Gilroy',
          //             ),
          //           ),
          //         ],
          //       ),
          SizedBox(height: ConstantUtil.verticalSpacing,)
        ],
      ),
    );
  }
}
