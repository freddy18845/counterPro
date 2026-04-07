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


class ConfigField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool enabled;
  final FocusNode? focusNode ;
  final bool obscureText;
  final bool showVisibilityToggle;
  final VoidCallback? onToggleVisibility;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const ConfigField({
    super.key,
    required this.controller,
    required this.hintText,
    this.textInputAction,
    this.validator,
    this.enabled = true,
    this.obscureText = false,
    this.showVisibilityToggle = false,
    this.onToggleVisibility,
    this.keyboardType,
    this.onChanged,
    this.focusNode,
    this.onSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ConstantUtil.loginInputWidth,
        height: ConstantUtil.maxOtpHeight,
        margin: EdgeInsets.symmetric(
            horizontal: 5
        ),
        decoration: BoxDecoration(
          color: Colors.black12.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.0, color: Colors.grey),
        ),
        alignment: Alignment.center,
        child: TextFormField(
      controller: controller,
          focusNode: focusNode,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
      cursorColor: AppColors.primaryColor,
      style: TextStyle(
        color: enabled ? Colors.black : Colors.black87,
        fontSize: 16,
      ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:  TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w200),
            // The Email Icon

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
            isDense: true,
            suffixIcon: showVisibilityToggle
                ? IconButton(
              icon: Icon(
                controller.text.isNotEmpty ? Icons.cancel : null,
                color: Colors.grey[600],
                size: 20,
              ),
              onPressed: onToggleVisibility,
            )
                : null,
          ),

      validator: validator,
        ));
  }
}


class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final IconData prexIcon;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool obscureText;
  final bool showVisibilityToggle;
  final Function(String)? onChanged;
  final VoidCallback? onToggleVisibility;
  final TextInputType? keyboardType;
  final int? maxLength;


  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prexIcon,
    this.validator,
    this.enabled = true,
    this.onChanged,
    this.obscureText = false,
    this.showVisibilityToggle = false,
    this.onToggleVisibility,
    this.keyboardType,
    this.maxLength,
    required this.label,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText; // initialise from prop
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: (ScreenUtil.width * 0.04).clamp(12.0, 14.0),
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: _obscure,           // ← use internal state
          keyboardType: widget.keyboardType,
          cursorColor: AppColors.primaryColor,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          style: TextStyle(
            fontSize: (ScreenUtil.height * 0.02).clamp(10, 14),
            fontWeight: FontWeight.normal,
            fontFamily: 'Gilroy',
            color: widget.enabled ? Colors.black : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.w200,
            ),
            prefixIcon: Icon(
              widget.prexIcon,
              color: Colors.grey,
              size: 20,
            ),
            filled: true,
            fillColor: Colors.grey.withAlpha(10),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
              const BorderSide(color: AppColors.green, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            isDense: true,
            // ← fixed suffix icon
            suffixIcon: widget.showVisibilityToggle
                ? IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
                size: 20,
              ),
              onPressed: () {
                setState(() => _obscure = !_obscure);
              },
            )
                : null,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}