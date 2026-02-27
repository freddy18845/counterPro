import "package:barcode_widget/barcode_widget.dart";
import "package:eswaini_destop_app/ux/utils/shared/app.dart";
import "package:eswaini_destop_app/ux/views/components/shared/receipt_item.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "../../../../../platform/utils/utils.dart";
import "../../../../platform/utils/constant.dart";
import "../../../blocs/shared/preview/bloc.dart";
import "../../../res/app_drawables.dart";
import "../../../res/app_strings.dart";
import "../../../res/app_theme.dart";
import "../../../utils/shared/screen.dart";
import "../../fragements/shared/short_dash_lines.dart";

class ReceiptViewSection extends StatelessWidget {
  final PreviewBloc previewBloc;

  const ReceiptViewSection({super.key, required this.previewBloc});

  Widget _headerText({required String text}) => Align(
    alignment: Alignment.center,
    child: Text(
      text,
      style: AppTheme.textStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> data = [];
    if (previewBloc.transaction.tenderType == '01') {
      data.add(
        const ReceiptItem(
          index: AppStrings.tenderType,
          value: AppStrings.card,
        ),
      );
      data.add(ReceiptItem(
          index: AppStrings.network,
          value: previewBloc.transaction.receivingNetworkName??"N/A"));
      data.add(
        ReceiptItem(
          index: AppStrings.cardNumber,
          value: (previewBloc.transaction.pan ?? "").toMaskedString(),
        ),
      );
    } else if (previewBloc.transaction.tenderType == '02') {
      data.add(
        const ReceiptItem(
          index: AppStrings.tenderType,
          value: AppStrings.mobileWallet,
        ),
      );
      data.add(ReceiptItem(
          index: AppStrings.network,
          value: previewBloc.transaction.receivingNetworkName??"N/A"));
      data.add(
        ReceiptItem(
          index: AppStrings.mobileNumber,
          value: previewBloc.transaction.pan ?? "",
        ),
      );
    } else {
      data.add(
        const ReceiptItem(
          index: AppStrings.tenderType,
          value: AppStrings.qrCode,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ConstantUtil.verticalSpacing,
        horizontal: ConstantUtil.horizontalSpacing,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppDrawables.receipt),
          fit: BoxFit.fill,
        ),
      ),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
      Container(
      padding: EdgeInsets.symmetric(
      vertical: ConstantUtil.verticalSpacing,
      ),
      child: SvgPicture.asset(
        AppDrawables.darkLogoSVG,
        fit: BoxFit.contain,
      ),
    ),
   SingleChildScrollView(
      child: Column(
        children: [
         // SizedBox(height: ScreenUtil.height * 0.015),
          _headerText(
            text: previewBloc.transaction.merchantName ?? "N/A",
          ),
          _headerText(
            text: previewBloc.transaction.merchantLocation ?? "N/A",
          ),
          _headerText(
            text: "${AppStrings.terminalId_} ${previewBloc.transaction.terminalId}" ?? "",
          ),
          _headerText(
            text: "${AppStrings.merchantID} ${previewBloc.transaction.merchantId}" ?? "",
          ),
          SizedBox(height: (ScreenUtil.height * 0.01).clamp(1, 1.5)),
          Text(
            ("${AppStrings.receipt}").toUpperCase(),
            style: AppTheme.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize:12,
            ),
          ),
          SizedBox(height: (ScreenUtil.height * 0.01).clamp(1, 1.5)),
          const DashedLine(),
          SizedBox(height: (ScreenUtil.height * 0.01).clamp(1, 1.5)),
          Text(
            getTransTypeText(
              transaction: previewBloc.transaction,
            ).toUpperCase(),
            style: AppTheme.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: (ScreenUtil.height * 0.01).clamp(1, 1.5)),
          const DashedLine(),
          SizedBox(height: (ScreenUtil.height * 0.01).clamp(1, 1.5)),
          // if (previewBloc.transaction.cashBackAmount != "0.00" ||
          //     previewBloc.transaction.cashBackAmount!.isNotEmpty)
          //   ReceiptItem(
          //     index: AppStrings.amount,
          //     value: AppUtil.getTransDisplayAmount(
          //       transaction: previewBloc.transaction,
          //     ),
          //   ),
          // ReceiptItem(
          //   index: AppStrings.cashBack,
          //   value: AppUtil.getTransDisplayCashBackAmount(
          //     transaction: previewBloc.transaction,
          //   ),
          // ),
          SizedBox(height: (ScreenUtil.height * 0.01).clamp(1, 1.5)),
          // Text(
          //   getResponseText(previewBloc.transaction.responseCode!),
          //   style: AppTheme.textStyle.copyWith(
          //     fontWeight: FontWeight.bold,
          //     fontSize: ScreenUtil.width * 0.035,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          SizedBox(height: (ScreenUtil.height * 0.01).clamp(1, 1.5)),
          ReceiptItem(
            index: AppStrings.transactionId,
            value: previewBloc.transaction.transactionId ?? "",
          ),
          ReceiptItem(
            index: AppStrings.authCode,
            value: previewBloc.transaction.authorizationCode ?? "",
          ),
          ReceiptItem(
            index: AppStrings.authRef,
            value: previewBloc.transaction.authorizationReference ?? "",
          ),
          SizedBox(height: (ScreenUtil.height * 0.01).clamp(1, 1.5)),
           const DashedLine(),
          SizedBox(height: (ScreenUtil.height * 0.01).clamp(1, 1.5)),
          // ReceiptItem(
          //   index: AppStrings.dateTime,
          //   value: getTransDisplayDate(
          //     transDate: previewBloc.transaction.dateTime ?? "",
          //   ).toUpperCase(),
          // ),
          Column(children: data),
          SizedBox(height: (ScreenUtil.height * 0.01).clamp(1, 1.5)),
          const DashedLine(),
          SizedBox(height: (ScreenUtil.height * 0.01).clamp(1, 1.5)),
          Text(
            AppStrings.thankYou,
            style: AppTheme.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil.width * 0.03,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          BarcodeWidget(
            barcode: Barcode.code93(),
            data: previewBloc.transaction.transactionId??"N/A",
            width: double.infinity,
            drawText: false,
            height: 20,
            style: _lightFontStyle(context, fontFamily: 'Gilroy'),
            color: Colors.black,
            backgroundColor: Colors.transparent,
          ),
          Text(
            '${AppStrings.transactionId}: ${previewBloc.transaction.transactionId}',
            style: _lightFontStyle(context).copyWith(fontWeight: FontWeight.bold),
          ),
        ],

    ),
    ) ]),
    )
        .animate(
      onPlay: (controller) => controller.forward(),
      autoPlay: true,
    )
        .fadeIn(
      begin: 0.0,
      duration: 400.ms,
      curve: Curves.easeIn,
    )
        .slideY(
      begin: -0.25,
      end: 0,
      duration: 600.ms,
      curve: Curves.easeOutCubic,
    )
        .then(delay: 100.ms)
        .scale(
      begin: const Offset(0.85, 0.85),
      end: const Offset(1.0, 1.0),
      duration: 1000.ms,
      curve: Curves.elasticOut,
    );


  }

  TextStyle _lightFontStyle(BuildContext context, {String? fontFamily}) {
    return TextStyle(
      color: Colors.black,
      fontSize: 11,
      fontFamily: fontFamily,
      fontWeight: FontWeight.w400,
    );
  }
}
