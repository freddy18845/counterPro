import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:flutter/material.dart";
import "../../../res/app_colors.dart";
import "../../../utils/shared/screen.dart";

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool autofocus;

  const EmailInputField({
    super.key,
    required this.controller,
    this.hintText = "Your Email Address",
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ConstantUtil.loginInputWidth,
        height: ConstantUtil.maxOtpHeight,
        margin: EdgeInsets.symmetric(
          horizontal: 20
        ),
        decoration: BoxDecoration(
          color: AppColors.cardOutlineColor.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.0, color: Colors.white),
        ),
        alignment: Alignment.center,
        child:TextFormField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next, // Moves to password field on 'Enter'
      style: const TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:  TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w200),
        // The Email Icon
        prefixIcon: const Icon(Icons.email_outlined, color: Colors.black54, size: 20),
        filled: true,
        fillColor: Colors.grey.withAlpha(20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        // Rounded Borders
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withAlpha(20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      // Email Validation Logic
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
        ).hasMatch(value);
        if (!emailValid) {
          return "Enter a valid email address";
        }
        return null;
      },
        ));
  }
}