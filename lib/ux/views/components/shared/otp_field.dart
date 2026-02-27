import "dart:async";
import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:flutter/material.dart";
import "../../../res/app_colors.dart";
import "otp_box.dart";
import 'dart:math' as math;

class OtpField extends StatefulWidget {
  final StreamController<Map>? controller;
  final int length; // Changed to int for List generation
  final bool secured;
  final Color? textColor;
  final Function(String)? onCompleted;

  const OtpField({
    super.key,
    this.controller,
    required this.length,
    required this.secured,
    this.textColor,
    this.onCompleted,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  // 1. Create lists to manage each individual box
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  StreamSubscription<Map>? _streamSub;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and nodes based on the length
    _controllers = List.generate(widget.length, (i) => TextEditingController());
    _focusNodes = List.generate(widget.length, (i) => FocusNode());

    // Listen to external stream (if you still want to set value remotely)
    if (widget.controller != null) {
      _streamSub = widget.controller?.stream.listen((event) {
        if (!mounted) return;
        if (event.containsKey("set_value")) {
          String val = event["set_value"];
          for (int i = 0; i < val.length && i < widget.length; i++) {
            _controllers[i].text = val[i];
          }
          setState(() {});
        }
      });
    }
    // --- ADD THIS BLOCK FOR INITIAL FOCUS ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNodes.isNotEmpty) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    for (var c in _controllers) {c.dispose();}
    for (var f in _focusNodes) {f.dispose();}
    super.dispose();
  }

  void _onBoxChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move focus forward
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    } else {
      // Move focus backward on delete
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    // Combine all digits and notify
    String result = _controllers.map((e) => e.text).join();
    if (result.length == widget.length && widget.onCompleted != null) {
      widget.onCompleted!(result);
    }
    setState(() {}); // Update colors
  }

  List<Widget> buildChildren({required double spacing, required double maxWidth}) {
    double boxSize = ConstantUtil.maxOtpHeight;


    return List.generate(widget.length, (index) {
      return OtpBox(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        secured: widget.secured,
        onChanged: (val) => _onBoxChanged(val, index),
        // Active color logic
        activeColor: _controllers[index].text.isNotEmpty
            ? AppColors.green
            : Colors.white,
        width: boxSize,
        height: boxSize,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double spacing =16;
    return LayoutBuilder(
      builder: (_, dimens) => Row( // Use Row for better alignment than Wrap

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buildChildren(spacing: spacing, maxWidth: dimens.maxWidth),
      ),
    );
  }
}