import "dart:async";
import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:eswaini_destop_app/ux/res/app_colors.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "../../../res/app_drawables.dart";
import "../../../res/app_theme.dart";
import "../../../utils/shared/screen.dart";

class NumPad extends StatefulWidget {
  final bool shuffle;
  final bool shuffleOnce;
  final bool isAmount;
  final String initialValue;
  final Color? textColor;
  final int limit;
  final void Function(String value) onInput;
  final void Function()? onCheckedAction;

  const NumPad({
    super.key,
    required this.onInput,
    this.initialValue = "",
    this.limit = 10,
    this.shuffle = false,

    this.isAmount = false,
    this.shuffleOnce = false,
    this.textColor,
    this.onCheckedAction,
  });

  @override
  State<NumPad> createState() => _NumPadState();
}

class _NumPadState extends State<NumPad> {
  Set<String> animatingKeys = {};

  late String input;

  List<List<String>> values = [
    ["1", "2", "3", "back"],
    ["4", "5", "6", "0"],
    ["7", "8", "9", "clear"],
  ];
  void processInput({required String value}) {
    bool updateSubmit = false;

    if (!animatingKeys.contains(value)) {
      setState(() {
        animatingKeys.add(value);
      });

      Future.delayed(const Duration(milliseconds: 150), () {
        setState(() {
          animatingKeys.remove(value);
        });
      });
    }

    if (value == "clear") {
      if (input.isNotEmpty) {
        input = "";
        updateSubmit = true;
      }
    } else if (value == "back") {
      if (input.isNotEmpty) {
        if (widget.textColor == Colors.white &&
            widget.onCheckedAction != null) {
          if (input.length >= widget.limit) {
            widget.onCheckedAction!();
          }
        } else {
          input = input.substring(0, input.length - 1);
          updateSubmit = true;
        }
      }
    } else if ("0123456789".contains(value)) {
      if (input.length < widget.limit) {
        if (widget.isAmount) {
          if (input.isEmpty && value != "0") {
            input += value;
            updateSubmit = true;
          } else if (input.isNotEmpty) {
            input += value;
            updateSubmit = true;
          }
        } else {
          input += value;
          updateSubmit = true;
        }
      }
    }

    if (updateSubmit) widget.onInput(input);
    if (widget.shuffle) shuffleNumSections();
  }

  void shuffleNumSections() {
    values[0].shuffle();
    values[1].shuffle();
    values[2].shuffle();
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        input = widget.initialValue;
      });
      if (widget.shuffleOnce) {
        shuffleNumSections();
      }
    });
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define your spacing
        const double spacing = 8.0;

        // Calculate width: (Total available width - total space between 4 buttons) / 4
        double buttonWidth = (constraints.maxWidth - (spacing * 3)) / 4;

        // Set your desired fixed height


        List<Widget> buttons = [];
        for (int a = 0; a < 3; a++) {
          for (int b = 0; b < 4; b++) {
            String currentValue = values[a][b];

            buttons.add(
              AnimatedScale(
                scale: animatingKeys.contains(currentValue) ? 0.95 : 1.0,
                duration: const Duration(milliseconds: 100),
                child: SizedBox(
                  width: buttonWidth,
                  height: ConstantUtil.maxHeightBtn, // Fixed height of 75
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (states) {
                          if (states.contains(WidgetState.pressed)) {
                            return AppColors.primaryColor;
                          }
                          return Colors.white;
                        },
                      ),
                      elevation: WidgetStateProperty.all(0),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                        ),
                      ),
                    ),



                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.white,
                    //   foregroundColor: widget.textColor ?? Colors.black,
                    //   elevation: 0,
                    //   padding: EdgeInsets.zero, // Ensures content isn't clipped
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(6),
                    //     side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    //   ),
                    // ),
                    onPressed: () => processInput(value: currentValue),
                    child: _buildButtonContent(currentValue),
                  ),
                ),
              ),
            );
          }
        }

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.start,
          children: buttons,
        );
      },
    );
  }

// Helper to handle the icon vs text logic
  Widget _buildButtonContent(String value) {
    final bool isPressed = animatingKeys.contains(value);

    Color textColor;

    if (value == "clear") {
      textColor = isPressed ? Colors.white : AppColors.red;
    } else {
      textColor = isPressed ? Colors.white : Colors.black;
    }

    if (value == "back") {
      return SvgPicture.asset(
        AppDrawables.clearSVG,
        height: 20,
       // color: textColor,
      );
    }

    return Text(
      value == "clear" ? "C" : value,
      style: AppTheme.textStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w200,
        fontFamily: 'Gilroy',
        color: textColor,
      ),
    );
  }


}
