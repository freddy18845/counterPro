import "dart:async";
import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:flutter/material.dart";
import "../../../Providers/transaction_provider.dart";
import "../../../models/terminal_sign_on_response.dart";
import "../../../res/app_strings.dart";
import "../../../res/app_theme.dart";
import "../../../utils/shared/screen.dart";
import "amount_to_pay.dart";
import "currency_selection.dart";
import "curve_amount_base.dart";

class AmountField extends StatefulWidget {
  final StreamController<Map>? controller;
  final bool selectedCurrency;
  final bool showSymbol;
  final Currency currency;
  final double? initialAmount;
  final void Function() onChangeCurrency;
  final double? scaleFactor;
  const AmountField({
    super.key,
    this.controller,
    this.selectedCurrency = false,
    this.scaleFactor = 1.8,
    this.initialAmount = 0.0,
    this.showSymbol = true,
    required this.currency,
    required this.onChangeCurrency,
  });

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  double amount = 0.0;
  StreamSubscription<Map>? _controller;

  @override
  void initState() {
    amount = widget.initialAmount ?? 0.0;
    if (widget.controller != null) {
      _controller = widget.controller?.stream.asBroadcastStream().listen((
        event,
      ) {
        if (!mounted) return;
        for (String action in event.keys) {
          if (action == "set_amount") {
            setState(() {
              amount = event[action];
            });
          }
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    try {
      if (_controller != null) {
        _controller?.cancel();
      }
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CurveAmountBase(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: ConstantUtil.verticalSpacing * 1.5),
            child: Text(
              AppStrings.enterAmount,
              style: AppTheme.textStyle.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                height: 1.0,
              ),
            ),
          ),

          // Currency and Amount in a row with spacing
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.selectedCurrency && widget.showSymbol) ...[
                Padding(
                  padding: EdgeInsets.only(
                    top: ConstantUtil.verticalSpacing ,
                  ),
                  child: CurrencySelectorButton(
                    isSingleCurrency:
                        (TransactionManager().currencies).length <= 1,
                    symbol: widget.currency.symbol ?? "",
                    onTap: () => widget.onChangeCurrency(),
                  ),
                ),
                SizedBox(width: 8), // Add spacing
              ],

              AmountToPay(
                amount: amount,
                symbol: widget.currency.symbol ?? "",
                decimals: int.tryParse(widget.currency.precision) ?? 2,
                scaleFactor: widget.scaleFactor ?? 1.0,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
