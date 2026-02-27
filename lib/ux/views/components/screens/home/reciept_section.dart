import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/blocs/shared/preview/bloc.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../res/app_drawables.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/shared/screen.dart';
import '../../shared/btn.dart';
import '../../shared/reciept_base.dart';

class ReceiptSection extends StatefulWidget {
  const ReceiptSection({super.key});

  @override
  State<ReceiptSection> createState() => _ReceiptSectionState();
}

class _ReceiptSectionState extends State<ReceiptSection> {
  late PreviewBloc previewBloc;

  @override
  void initState() {
    previewBloc = context.read<PreviewBloc>();
    previewBloc.init(context: context);
    super.initState();
  }

  @override
  void dispose() {
    try {
      previewBloc.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (ScreenUtil.width * 0.2).clamp(
        ConstantUtil.maxReceiptCardWidth,
        600,
      ),
      padding: EdgeInsets.symmetric(
        vertical: ConstantUtil.verticalSpacing,
        horizontal: ConstantUtil.horizontalSpacing,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardOutlineColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.receiptHistory,
            style: TextStyle(
              fontSize: (ScreenUtil.height * 0.04).clamp(12, 14),
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w900,
              fontFamily: 'Gilroy',
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              AppStrings.previewReceipt,
              style: TextStyle(
                fontSize: (ScreenUtil.height * 0.02).clamp(9, 10),
                fontWeight: FontWeight.normal,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<PreviewBloc, PreviewState>(
              bloc: previewBloc,
              builder: (context, state) {
                if (previewBloc.transaction == null) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: ConstantUtil.verticalSpacing,
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
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: ConstantUtil.verticalSpacing * 6),
                              SvgPicture.asset(
                                AppDrawables.emptyReceiptSVG,
                                height: ScreenUtil.height * 0.064,
                                width: ScreenUtil.width * 0.046,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ConstantUtil.horizontalSpacing,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppStrings.completeATransactionToViewAReceipt,
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: (ScreenUtil.height * 0.02).clamp(9, 10),
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Gilroy',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ReceiptViewSection(previewBloc: previewBloc);
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ConstantUtil.horizontalSpacing,
            ),
            child: Btn(
              isActive: true,
              btnHeight: 40,
              bgImage: AppDrawables.blueCard,
              text: AppStrings.print,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}