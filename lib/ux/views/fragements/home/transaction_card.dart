import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/res/app_drawables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/screens/home/flow_item.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_strings.dart';
import '../../../utils/shared/screen.dart';

class TransactionCard extends StatefulWidget {
  final HomeFlowItem item;
  final String title;
  const TransactionCard({super.key, required this.item, required this.title});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {



  @override
  Widget build(BuildContext context) {
    // 1. Define spacings
    const double dividerPadding = 11.0;
    const double dividerWidth = 1.5;
    const double totalDividerSpace = (dividerPadding * 2) + dividerWidth;

    // 2. Calculate Segment Width (the total space available per item)
    final double availableWidth =(ScreenUtil.height * 1.57)- ConstantUtil.maxReceiptCardWidth-(ConstantUtil.horizontalSpacing *4);
    final double segmentWidth = availableWidth / ConstantUtil.options.length;

    // 3. FIX: Subtract the divider space from ALL cards.
    // This ensures the actual blue/grey card is the same size for everyone.
    final double cardWidth = segmentWidth - totalDividerSpace;

    final bool isLastItem = widget.item.text == AppStrings.reports;

    return  SizedBox(
    width: segmentWidth,
        child: Row(
          // Ensure the card and divider stay aligned to the start of their segment
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // THE CARD (Now uniform size)
            Container(
              width: cardWidth,
              height: (ScreenUtil.height * 0.14),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                color:widget.item.text==widget.title?AppColors.secondaryColor: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        image: const DecorationImage(
                          image: AssetImage(AppDrawables.blueCard),
                          fit: BoxFit.fill,
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.secondaryColor,
                            width: 3.0,
                          ),
                        ),
                      ),

                      child: Center(
                        child: SvgPicture.asset(
                          widget.item.icon,
                          // Remove fit: BoxFit.fitHeight if you want strict height/width control
                          height: (ScreenUtil.height * 0.03),
                          width: (ScreenUtil.height * 0.03),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.item.text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: (ScreenUtil.height * 0.015),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // THE DIVIDER (Only drawn if not last)
            if (!isLastItem)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: dividerPadding),
                height: 60,
                width: dividerWidth,
                color: Colors.white.withOpacity(0.5),
              ),
          ],
        ),
      )
    ;
  }
}
