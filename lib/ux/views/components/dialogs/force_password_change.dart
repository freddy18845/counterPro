// lib/ux/views/components/dialogs/force_password_change.dart
import 'package:eswaini_destop_app/platform/utils/isar_manager.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_user.dart';
import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:flutter/material.dart';
import '../../../models/shared/transaction.dart';
import '../shared/base_dailog.dart';
import '../shared/btn.dart';
import '../shared/login_input.dart';

class ForcePasswordChangeDialog extends StatefulWidget {
  final PosUser user;
  const ForcePasswordChangeDialog({
    super.key,
    required this.user,
  });

  @override
  State<ForcePasswordChangeDialog> createState() =>
      _ForcePasswordChangeDialogState();
}

class _ForcePasswordChangeDialogState
    extends State<ForcePasswordChangeDialog> {
  final _newPasswordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final isar = IsarService.db;
  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    widget.user.passwordHash =
        _newPasswordController.text;
    widget.user.updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.posUsers.put(widget.user);
    });

    setState(() => _isLoading = false);

    if (mounted) {
      AppUtil.toastMessage(
        message: '✅ Password changed successfully',
        context: context,
        backgroundColor: Colors.green,
      );

      Navigator.pop(context);
      AppNavigator.gotoHome(TransactionData(),context: context);
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // ← cannot skip this step
      child: DialogBaseLayout(
        title: 'Set Your Password',
        showCard: true,
        titleSize: 14,
        cardHeight: 380,
        cardWidth: 440,
        onClose: null, // ← no close button — must complete
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),

              // info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange
                      .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.orange
                          .withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                        Icons.lock_reset_outlined,
                        size: 16,
                        color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Welcome ${widget.user.name}! '
                            'Your account was set up remotely. '
                            'Please create a new password to continue.',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              InputField(
                label: 'New Password',
                controller: _newPasswordController,
                hintText: 'Enter your new password',
                prexIcon: Icons.lock_outline,
                obscureText: true,
                showVisibilityToggle: true,
                validator: (v) {
                  if (v == null || v.length < 6) {
                    return 'Minimum 6 characters';
                  }
                  if (v == 'changeme123') {
                    return 'Choose a different password';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              InputField(
                label: 'Confirm Password',
                controller: _confirmController,
                hintText: 'Confirm your new password',
                prexIcon: Icons.lock_outline,
                obscureText: true,
                showVisibilityToggle: true,
                validator: (v) {
                  if (v != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ColorBtn(
                  text: _isLoading
                      ? 'Saving...'
                      : 'Set Password & Continue',
                  btnColor: AppColors.primaryColor,
                  action: _isLoading
                      ? (){}
                      : _changePassword,
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}