import "package:flutter/material.dart";
import "package:flutter/services.dart";

class OtpBox extends StatelessWidget {
  final double width;
  final double height;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color activeColor;
  final bool secured;
  final ValueChanged<String> onChanged;

  const OtpBox({
    super.key,
    required this.width,
    required this.height,
    required this.controller,
    required this.focusNode,
    required this.activeColor,
    required this.onChanged,
    this.secured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 2.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1.0, color: activeColor),
      ),
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        cursorColor: Colors.black54,
        maxLength: 1,
        obscureText: secured,
        cursorHeight: 12,
        obscuringCharacter: "●",
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],

        decoration: const InputDecoration(
          counterText: "",

          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 8),
        ),
      ),
    );
  }
}