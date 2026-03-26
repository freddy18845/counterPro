import "package:eswaini_destop_app/platform/utils/isar_manager.dart";
import "package:eswaini_destop_app/ux/models/shared/pos_user.dart";
import "package:eswaini_destop_app/ux/models/shared/transaction.dart";
import "package:eswaini_destop_app/ux/nav/app_navigator.dart";
import "package:eswaini_destop_app/ux/res/app_strings.dart";
import "package:eswaini_destop_app/ux/utils/shared/app.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_svg/svg.dart";
import "package:isar/isar.dart";
import "../../../../../platform/utils/constant.dart";
import "../../../../blocs/screens/login/bloc.dart";
import "../../../../res/app_colors.dart";
import "../../../../res/app_drawables.dart";
import "../../../../utils/remember_me.dart";
import "../../../../utils/sessionManager.dart";
import "../../shared/btn.dart";
import "../../shared/login_input.dart";
import "../../../../utils/shared/screen.dart";

// ── Screen mode enum ──────────────────────────────────────────
enum _LoginMode { login, forgotPassword, resetPassword }

class LoginPasswordSection extends StatefulWidget {
  final LoginBloc loginBloc;
  final String subText;
  final bool isLoading;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function(String value) onSetValue;

  const LoginPasswordSection({
    super.key,
    required this.loginBloc,
    required this.subText,
    required this.isLoading,
    required this.emailController,
    required this.passwordController,
    required this.onSetValue,
  });

  @override
  State<LoginPasswordSection> createState() => _State();
}

class _State extends State<LoginPasswordSection> {
  final _loginFormKey = GlobalKey<FormState>();
  final _forgotFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();
  final isar = IsarService.db;
  bool isLoading = false;

  _LoginMode _mode = _LoginMode.login;

  // forgot password
  final _forgotEmailController = TextEditingController();
  String? _forgotMessage;

  // reset password
  final _resetEmailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _resetMessage;
  final _rememberMe = RememberMeManager();
  bool _rememberMeChecked = false;
  bool _resetSuccess = false;


  @override
  void initState() {
    super.initState();
    _initRememberMe();
  }



  @override
  void dispose() {
    _forgotEmailController.dispose();
    _resetEmailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  Future<void> _initRememberMe() async {
    await _rememberMe.load();

    if (!mounted) return;

    if (_rememberMe.hasSavedCredentials) {
      widget.emailController.text = _rememberMe.savedEmail ?? '';
      widget.passwordController.text = _rememberMe.savedPassword ?? '';

      setState(() {
        _rememberMeChecked = true;
      });
    }
  }

  // ── Login ─────────────────────────────────────────────────
  Future<void> login() async {
    if (!_loginFormKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final user = await isar.posUsers
        .where()
        .filter()
        .emailEqualTo(widget.emailController.text.trim())
        .and()
        .passwordHashEqualTo(widget.passwordController.text)
        .and()
        .isActiveEqualTo(true)
        .findFirst();

    if (!mounted) return;

    

    if (user == null) {
      AppUtil.toastMessage(
        message: '❌ Invalid Email or Password',
        context: context,
        backgroundColor: Colors.red,
      );
      return;
    }

    // ✅ SAVE remember me
    await _rememberMe.save(
      email: widget.emailController.text.trim(),
      password: widget.passwordController.text,
      rememberMe: _rememberMeChecked,
    );

    // ✅ Save session
    SessionManager().save(user, context);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isLoading = false;
    });
    AppNavigator.gotoHome(TransactionData(),context: context);
  }

  // ── Forgot password ───────────────────────────────────────
  Future<void> _handleForgotPassword() async {
    if (!_forgotFormKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final email = _forgotEmailController.text.trim();

    final user = await isar.posUsers
        .where()
        .filter()
        .emailEqualTo(email)
        .findFirst();

    setState(() => isLoading = false);

    if (user == null) {
      setState(() => _forgotMessage = '❌ No Account Found For $email');
      return;
    }

    setState(() {
      _resetEmailController.text = email;
      _mode = _LoginMode.resetPassword;
    });
  }

  // ── Reset password ────────────────────────────────────────
  Future<void> _handleResetPassword() async {
    if (!_resetFormKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _resetMessage = '❌ Passwords do not match');
      return;
    }

    setState(() => isLoading = true);

    final email = _resetEmailController.text.trim();
    final newPassword = _newPasswordController.text;

    final user = await isar.posUsers
        .where()
        .filter()
        .emailEqualTo(email)
        .findFirst();

    if (user == null) {
      setState(() {
        isLoading = false;
        _resetMessage = '❌ No Account Found';
      });
      return;
    }

    user.passwordHash = newPassword;
    user.updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.posUsers.put(user);
    });

    if (_rememberMe.savedEmail == email) {
      await _rememberMe.updatePassword(newPassword);
    }

    setState(() {
      isLoading = false;
      _resetSuccess = true;
      _resetMessage = '✅ Password Reset Successful';
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _mode = _LoginMode.login;
      _resetMessage = null;
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }



  // ── UI helpers ────────────────────────────────────────────
  String get _title {
    switch (_mode) {
      case _LoginMode.login:
        return widget.subText;
      case _LoginMode.forgotPassword:
        return 'Forgot Password';
      case _LoginMode.resetPassword:
        return 'Reset Password';
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _mode == _LoginMode.login
    ? _loginFormKey
        : _mode == _LoginMode.forgotPassword
        ? _forgotFormKey
        : _resetFormKey,
      child: Container(
        width: ConstantUtil.loginInputWidth,
        decoration: BoxDecoration(
          color: AppColors.cardOutlineColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 5),
        ),
        child:
        SingleChildScrollView(
         child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            // logo
            Center(
              child:Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SvgPicture.asset(
                AppDrawables.darkLogoSVG,
                width: 90,
                height: 50,
                fit: BoxFit.fitWidth,
                ) ),
            ),
Divider(thickness: 0.8,color: Colors.grey,),
            // title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                _title,
                style: TextStyle(
                  fontSize: (ScreenUtil.height * 0.02).clamp(10, 14),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy',
                ),
              ),
            ),

            // ── Login fields ────────────────────────────────
            if (_mode == _LoginMode.login) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InputField(
                  label: 'Email',
                  controller: widget.emailController,
                  hintText: 'Email',
                  enabled: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your Email';
                    }
                    final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value);
                    if (!emailValid) return 'Enter a valid email address';
                    return null;
                  },
                  prexIcon: Icons.email,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InputField(
                  label: 'Password',
                  controller: widget.passwordController,
                  hintText: 'Password',
                  enabled: true,
                  keyboardType: TextInputType.visiblePassword,
                  showVisibilityToggle: true,
                  obscureText: true,
                  validator: (v) =>
                  v == null || v.length < 4 ? 'Min 4 characters' : null,
                  prexIcon: Icons.lock,
                ),
              ),
              const SizedBox(height: 8),

              // remember me + forgot password row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // remember me
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _rememberMeChecked = !_rememberMeChecked;
                        });

                        if (!_rememberMeChecked) {
                          await _rememberMe.clear();
                        }
                      },
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 18,
                            height: 16,
                            decoration: BoxDecoration(
                              color: _rememberMeChecked
                                  ? AppColors.green
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _rememberMeChecked
                                    ? AppColors.loaderGreen
                                    : Colors.grey,
                                width: 1.5,
                              ),
                            ),
                            child: _rememberMeChecked
                                ? const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            )
                                : null,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // forgot password
                    GestureDetector(
                      onTap: () => setState(() {
                        _mode = _LoginMode.forgotPassword;
                        _forgotMessage = null;
                      }),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: 'Gilroy',
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── Forgot password fields ──────────────────────
            if (_mode == _LoginMode.forgotPassword) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Enter your email address and we will redirect you to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (ScreenUtil.height * 0.016).clamp(10, 13),

                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InputField(
                  label: 'Email Address',
                  controller: _forgotEmailController,
                  hintText: 'Enter your email',
                  enabled: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value);
                    if (!emailValid) return 'Enter a valid email address';
                    return null;
                  },
                  prexIcon: Icons.email_outlined,
                ),
              ),
              if (_forgotMessage != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _forgotMessage!,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.red),
                  ),
                ),
              ],
            ],

            // ── Reset password fields ───────────────────────
            if (_mode == _LoginMode.resetPassword) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InputField(
                  label: 'Email Address',
                  controller: _resetEmailController,
                  hintText: 'Confirm your email',
                  enabled: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  prexIcon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InputField(
                  label: 'New Password',
                  controller: _newPasswordController,
                  hintText: 'Enter new password',
                  enabled: true,
                  keyboardType: TextInputType.visiblePassword,
                  showVisibilityToggle: true,
                  obscureText: true,
                  validator: (v) =>
                  v == null || v.length < 4 ? 'Min 4 characters' : null,
                  prexIcon: Icons.lock_outline,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InputField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  hintText: 'Confirm new password',
                  enabled: true,
                  keyboardType: TextInputType.visiblePassword,
                  showVisibilityToggle: true,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.length < 4) return 'Min 4 characters';
                    if (v != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  prexIcon: Icons.lock_outline,
                ),
              ),
              if (_resetMessage != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _resetMessage!,
                    style: TextStyle(
                      fontSize: 12,
                      color: _resetSuccess ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],

            const SizedBox(height: 18),

            // ── Action buttons ──────────────────────────────
            Container(
              width: ConstantUtil.loginInputWidth,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 28,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardOutlineColor.withValues(alpha: 0.4),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: _mode == _LoginMode.login
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ColorBtn(
                      text: AppStrings.cancel,
                      btnColor: AppColors.red,
                      action: () {
                        SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ColorBtn(
                      text: isLoading
                          ? AppStrings.logging
                          : AppStrings.login,
                      btnColor: AppColors.secondaryColor,
                      action: login,
                    ),
                  ),
                ],
              )
                  : _mode == _LoginMode.forgotPassword
                  ? Row(
                children: [
                  Expanded(
                    child: ColorBtn(
                      text: 'Back',
                      btnColor: AppColors.red,
                      action: () => setState(() {
                        _mode = _LoginMode.login;
                        _forgotMessage = null;
                        _forgotEmailController.clear();
                      }),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ColorBtn(
                      text: isLoading ? 'Checking...' : 'Continue',
                      btnColor: AppColors.secondaryColor,
                      action: _handleForgotPassword,
                    ),
                  ),
                ],
              )
                  : Row(
                children: [
                  Expanded(
                    child: ColorBtn(
                      text: 'Back',
                      btnColor: AppColors.red,
                      action: () => setState(() {
                        _mode = _LoginMode.forgotPassword;
                        _resetMessage = null;
                      }),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ColorBtn(
                      text: isLoading
                          ? 'Resetting...'
                          : 'Reset Password',
                      btnColor: AppColors.secondaryColor,
                      action: _handleResetPassword,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .slideY(begin: -0.1, end: 0, curve: Curves.easeOutCubic)
        .blur(begin: const Offset(10, 10), end: Offset.zero);
  }
}
