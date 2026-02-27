import "package:eswaini_destop_app/ux/res/app_drawables.dart";
import "package:flutter/material.dart";
import "../../../Providers/transaction_provider.dart";
import "../../../models/terminal_sign_on_response.dart";
import "../../../res/app_colors.dart";
import "../../../res/app_strings.dart";
import "../../../res/app_theme.dart";
import "../../../utils/shared/screen.dart";
import "../shared/base_dailog.dart";

class CurrencyDialog extends StatefulWidget {
  final Currency selectedCurrency;

  const CurrencyDialog({super.key, required this.selectedCurrency});

  @override
  State<CurrencyDialog> createState() => _CurrencyDialogState();
}

class _CurrencyDialogState extends State<CurrencyDialog> {
  int? _hoveredIndex;
  @override
  Widget build(BuildContext context) {
    List<Currency> currencies = (TransactionManager().currencies);
    return PopScope(
      canPop: false,
      child: DialogBaseLayout(
        titleSize: 16,
        // topPadding:ScreenUtil.height * 0.35,
        title: AppStrings.selectTransactionCurrency,
        onClose: () {
          List<Currency> currencies = TransactionManager().currencies;

          // Check if symbol exists and is not empty, otherwise use first currency
          Currency finalCurrency;
          if (widget.selectedCurrency.symbol != null &&
              widget.selectedCurrency.symbol.isNotEmpty) {
            finalCurrency = widget.selectedCurrency;
          } else {
            finalCurrency = currencies.isNotEmpty
                ? currencies[0]
                : widget.selectedCurrency;
          }

          Navigator.pop(context, finalCurrency);
        },

        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.cardOutlineColor,
          ),
          width: (ScreenUtil.width * 0.02).clamp(400, 520),
          child: Row(
            spacing: ScreenUtil.width * 0.015,
            children: currencies
                .asMap()
                .entries
                .map(
                  (item) => Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, item.value);
                      },
                      child: Expanded(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) =>
                              setState(() => _hoveredIndex = item.key),
                          onExit: (_) => setState(() => _hoveredIndex = null),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context, item.value);
                            },
                            child: AnimatedScale(
                              scale: _hoveredIndex == item.key ? 1.05 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: (ScreenUtil.height * 0.08).clamp(
                                  100,
                                  120,
                                ),
                                width: (ScreenUtil.width * 0.02).clamp(
                                  300,
                                  420,
                                ),
                                decoration: _hoveredIndex == item.key
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            AppDrawables.blueCard,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                alignment: Alignment.center,
                                child: Text(
                                  (item.value.alphaCode).toUpperCase(),
                                  style: AppTheme.textStyle.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: (ScreenUtil.width * 0.04).clamp(
                                      30,
                                      40,
                                    ),
                                    color: _hoveredIndex == item.key
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Container(
                      //   height: (ScreenUtil.height * 0.08).clamp(100, 120),
                      //   width: (ScreenUtil.width * 0.02).clamp(300, 420),
                      //   decoration: BoxDecoration(
                      //     borderRadius:
                      //     BorderRadius.circular(10,),
                      //     color: Colors.white,
                      //   ),
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     (item.value.alphaCode).toUpperCase(),
                      //     style: AppTheme.textStyle.copyWith(
                      //       fontWeight: FontWeight.w800,
                      //       fontSize: (ScreenUtil.width * 0.04).clamp(30, 40),
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
