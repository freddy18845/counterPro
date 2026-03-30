// ─────────────────────────────────────────────────────────────
// ── EXISTING BUSINESS CARD (API key flow) ─────────────────────
// ─────────────────────────────────────────────────────────────
import 'package:eswaini_destop_app/ux/models/shared/company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:isar/isar.dart';

import '../../../../../platform/utils/isar_manager.dart';
import '../../../../models/shared/pos_user.dart';
import '../../../../nav/app_navigator.dart';
import '../../../../res/app_colors.dart';
import '../../../../utils/api_service.dart';
import '../../../../utils/shared/api_config.dart';
import '../../../../utils/shared/app.dart';
import '../../../../utils/shared/screen.dart';
import '../../../fragements/configSetting/sync_result.dart';
import '../../../fragements/configSetting/sync_service.dart';
import '../../shared/btn.dart';
import '../../shared/login_input.dart';

class ExistingBusinessCard extends StatefulWidget {
  const ExistingBusinessCard({super.key});

  @override
  State<ExistingBusinessCard> createState() =>
      ExistingBusinessCardState();
}

class ExistingBusinessCardState
    extends State<ExistingBusinessCard> {
  final _apiKeyController = TextEditingController();
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isValidated = false;
  String _progress = '';
  SyncResult? _syncResult;

  // ── Steps ──────────────────────────────────────────────────
  // 1. Validate API key
  // 2. Pull all data (company, users, products etc)
  // 3. Auto-detect admin user from pulled users
  // 4. Navigate to login

  @override
  void initState() {
    super.initState();
    _urlController.text = ApiConfig.defaultBaseUrl;
    //  _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final key = await ApiConfig.getApiKey();
    final url = await ApiConfig.getBaseUrl();
    if (key != null && key.isNotEmpty) {
      _apiKeyController.text = key;
    }
    if (url.isNotEmpty) {
      _urlController.text = url;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  // ── Step 1: validate API key ──────────────────────────────
  Future<void> _validate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _progress = 'Validating API key...';
      _isValidated = false;
      _syncResult = null;
    });

    // save credentials
    await ApiConfig.setApiKey(
        _apiKeyController.text.trim());
    await ApiConfig.setBaseUrl(
        _urlController.text.trim());
    await ApiConfig.setSyncEnabled(true);

    // validate with server
    final authService = AuthApiService();
    final res = await authService
        .validateApiKey(_apiKeyController.text.trim());

    if (!res.success) {
      setState(() {
        _isLoading = false;
        _progress = '';
      });

      if (mounted) {
        AppUtil.toastMessage(
          message: '❌ Invalid API key: ${res.error}',
          context: context,
          backgroundColor: Colors.red,
        );
      }
      return;
    }

    // ── Step 2: pull all data ──────────────────────────────
    setState(() => _progress = 'Fetching your data...');

    // listen to progress messages
    final sub =
    SyncService().progressStream.listen((msg) {
      if (mounted) setState(() => _progress = msg);
    });

    final result = await SyncService().firstTimeSetup(context);
    sub.cancel();

    setState(() {
      _isLoading = false;
      _syncResult = result;
      _isValidated = result.pulled > 0 || !result.hasErrors;
      _progress = '';
    });

    if (!mounted) return;

    if (result.hasErrors && result.pulled == 0) {
      AppUtil.toastMessage(
        message:
        '❌ Could not load data. Check your API key.',
        context: context,
        backgroundColor: Colors.red,
      );
      return;
    }

    AppUtil.toastMessage(
      message:
      '✅ Data loaded — ${result.pulled} records pulled',
      context: context,
      backgroundColor: Colors.green,
    );
  }

  // ── Step 3 & 4: go to login ───────────────────────────────
  // After pulling data the users are already in Isar
  // including the admin. We go straight to login.
  // The user logs in with their existing credentials.
  // If it's first pull passwords are 'changeme123' — they
  // will be prompted to change on first login.
  Future<void> _goToLogin() async {
    // verify that we actually have users and company
    final isar = IsarService.db;
    final company =
    await isar.companys.where().findFirst();
    final adminUser = await isar.posUsers
        .where()
        .filter()
        .roleEqualTo(UserRole.admin)
        .findFirst();

    if (company == null || adminUser == null) {
      if (mounted) {
        AppUtil.toastMessage(
          message:
          '❌ No company or admin user found. Check your API key.',
          context: context,
          backgroundColor: Colors.red,
        );
      }
      return;
    }

    if (mounted) {
      AppNavigator.gotoLogin(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (ScreenUtil.width * 0.55).clamp(320, 600),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardOutlineColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 5),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor
                        .withValues(alpha: 0.1),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: const Icon(
                      Icons.business_center_outlined,
                      color:  AppColors.secondaryColor,
                      size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Existing Business',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      Text(
                        'Restore Your Data Using API Access',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),

            // how it works
            const Text(
              'How It Works:',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
            ),
            const SizedBox(height: 10),

            ...[
              ('1️⃣', 'Enter your API Key And Server URL'),
              ('2️⃣', 'We Fetch All Your Business Data'),
              ('3️⃣', 'Log in With Your Existing Credentials'),
              ('4️⃣', 'Continue Where you Left off'),
            ].map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Text(item.$1,
                      style:
                      const TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item.$2,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87)),
                  ),
                ],
              ),
            )),

            const SizedBox(height: 16),

            // API Key field
            InputField(
              label: 'API Key',
              controller: _apiKeyController,
              hintText: 'Enter your CounterPro API key',
              prexIcon: Icons.key_outlined,
              obscureText: true,
              showVisibilityToggle: true,
              enabled: !_isLoading,
              validator: (v) => v == null || v.isEmpty
                  ? 'API key is required'
                  : null,
            ),
            const SizedBox(height: 12),
            InputField(
              label: 'Server URL',
              controller: _urlController,
              hintText: 'Enter Your Dedicated Url',
              prexIcon: Icons.link_outlined,
              enabled: !_isLoading,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Server URL is required';
                if (!v.startsWith('http')) return 'URL must start with http or https';
                return null;
              },
            ),


            const SizedBox(height: 16),

            // progress indicator
            if (_isLoading) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor
                      .withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.primaryColor
                          .withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child:CupertinoActivityIndicator(radius: 18, color: AppColors.primaryColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _progress,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // sync result
            if (_syncResult != null && !_isLoading) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (_syncResult!.hasErrors &&
                      _syncResult!.pulled == 0)
                      ? Colors.red
                      .withValues(alpha: 0.06)
                      : Colors.green
                      .withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (_syncResult!.hasErrors &&
                        _syncResult!.pulled == 0)
                        ? Colors.red
                        .withValues(alpha: 0.3)
                        : Colors.green
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isValidated
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          size: 16,
                          color: _isValidated
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isValidated
                              ? '${_syncResult!.pulled} Records Loaded Successfully'
                              : 'Failed To Load Data',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _isValidated
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    if (_syncResult!.hasErrors) ...[
                      const SizedBox(height: 6),
                      ..._syncResult!.errors
                          .take(3)
                          .map((e) => Text(
                        '• $e',
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.red),
                      )),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // action buttons
            if (!_isValidated) ...[
              SizedBox(
                width: double.infinity,
                child: ColorBtn(

                  text: _isLoading
                      ? 'Loading...'
                      : 'Fetch My Data  →',
                  btnColor:  AppColors.secondaryColor,
                  action: _isLoading ? (){} : _validate,
                ),
              ),
            ] else ...[
              // data loaded — show login button
              SizedBox(
                width: double.infinity,
                child: ColorBtn(
                  text: 'Continue to Login  →',
                  btnColor: AppColors.primaryColor,
                  action: _goToLogin,
                ),
              ),
              const SizedBox(height: 10),
              // retry option
              SizedBox(
                width: double.infinity,
                child: ColorBtn(
                  text: 'Fetch Again',
                  btnColor: Colors.grey,
                  action: () => setState(() {
                    _isValidated = false;
                    _syncResult = null;
                  }),
                ),
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.05, end: 0);
  }
}