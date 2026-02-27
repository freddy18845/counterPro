import "dart:async";
import "package:flutter/material.dart";
import "../../../res/app_colors.dart";
import "otp_box.dart";

class OtpInput extends StatefulWidget {
  final int length;
  final bool secured;
  final bool isLoading;
  final void Function(String value) onChange;
  final void Function(String value)? onCompleted;

  const OtpInput({
    super.key,
    this.length = 6,
    this.secured = true,
    this.isLoading = false,
    required this.onChange,
    this.onCompleted,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (i) => TextEditingController());
    _focusNodes = List.generate(widget.length, (i) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next box
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    } else {
      // Move to previous box on backspace
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    // Collect full string
    String currentOtp = _controllers.map((e) => e.text).join();
    widget.onChange(currentOtp);

    if (currentOtp.length == widget.length && widget.onCompleted != null) {
      widget.onCompleted!(currentOtp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double spacing = 8.0;
      double boxSize = (constraints.maxWidth - (spacing * (widget.length - 1))) / widget.length;
      boxSize = boxSize.clamp(40.0, 55.0);

      return Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.length, (index) {
              return OtpBox(
                width: boxSize,
                height: boxSize,
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                secured: widget.secured,
                activeColor: _focusNodes[index].hasFocus ? AppColors.green : Colors.grey.withAlpha(100),
                onChanged: (val) => _handleChanged(val, index),
              );
            }),
          ),
          if (widget.isLoading)
            const CircularProgressIndicator(color: AppColors.green),
        ],
      );
    });
  }
}