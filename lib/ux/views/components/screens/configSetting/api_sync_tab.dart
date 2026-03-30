// lib/ux/views/components/screens/configSetting/api_sync_tab.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/api_service.dart';
import '../../../../utils/shared/api_config.dart';
import '../../../fragements/configSetting/forms.dart';
import '../../../fragements/configSetting/guide_card.dart';
import '../../../fragements/configSetting/result_chip.dart';
import '../../../fragements/configSetting/sync_card.dart';
import '../../../fragements/configSetting/sync_result.dart';
import '../../../fragements/configSetting/sync_service.dart';

import 'section_title.dart';

class ApiSyncTab extends StatefulWidget {
  const ApiSyncTab({super.key});

  @override
  State<ApiSyncTab> createState() => _ApiSyncTabState();
}

class _ApiSyncTabState extends State<ApiSyncTab> {
  final _apiKeyController = TextEditingController();
  final _baseUrlController = TextEditingController();

  bool _syncEnabled = false;
  bool _isSyncing = false;
  bool _isValidating = false;
  bool _isSaving = false;
  bool _isConnected = false;

  SyncResult? _lastResult;
  DateTime? _lastSyncTime;

  Timer? _autoSyncTimer;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    _autoSyncTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final apiKey = await ApiConfig.getApiKey();
    final baseUrl = await ApiConfig.getBaseUrl();
    final syncEnabled = await ApiConfig.isSyncEnabled();
    await SyncService().loadLastSyncTime();

    setState(() {
      _apiKeyController.text = apiKey ?? '';
      _baseUrlController.text = baseUrl;
      _syncEnabled = syncEnabled;
      _lastSyncTime = SyncService().lastSyncTime;
      _isConnected = syncEnabled;
    });
  }

  Future<void> _saveSettings() async {
    if (_apiKeyController.text.trim().isEmpty) {
      AppUtil.toastMessage(
        message: 'Please enter an API key',
        context: context,
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => _isSaving = true);

    await ApiConfig.setApiKey(_apiKeyController.text.trim());
    await ApiConfig.setBaseUrl(_baseUrlController.text.trim());
    await ApiConfig.setSyncEnabled(_syncEnabled);

    setState(() => _isSaving = false);

    if (mounted) {
      AppUtil.toastMessage(
        message: '✅ API Settings Saved',
        context: context,
        backgroundColor: Colors.green,
      );
    }
  }

  Future<void> _validateApiKey() async {
    if (_apiKeyController.text.trim().isEmpty) {
      AppUtil.toastMessage(
        message: 'Please enter an API key first',
        context: context,
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => _isValidating = true);

    final authService = AuthApiService();
    final response = await authService.validateApiKey(
      _apiKeyController.text.trim(),
    );

    setState(() {
      _isValidating = false;
      _isConnected = response.success;
    });

    if (mounted) {
      AppUtil.toastMessage(
        message: response.success
            ? '✅ API key is valid'
            : '❌ Invalid API key: ${response.error}',
        context: context,
        backgroundColor: response.success ? Colors.green : Colors.red,
      );
    }
  }

  Future<void> _syncNow() async {
    if (SyncService().isSyncing) return;

    setState(() {
      _isSyncing = true;
      _lastResult = null;
    });

    final result = await SyncService().syncAll(context: context);

    setState(() {
      _isSyncing = false;
      _lastResult = result;
      _lastSyncTime = SyncService().lastSyncTime;
    });

    if (mounted) {
      AppUtil.toastMessage(
        message: result.hasErrors
            ? '⚠️ Sync completed with ${result.failed} errors'
            : '✅ Sync complete — ${result.pushed} pushed, ${result.pulled} pulled',
        context: context,
        backgroundColor: result.hasErrors ? Colors.orange : Colors.green,
      );
    }
  }

  String _formatSyncTime(DateTime? dt) {
    if (dt == null) return 'Never';
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Connection status ─────────────────────────
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: _syncEnabled
          //         ? Colors.green.withValues(alpha: 0.08)
          //         : Colors.grey.withValues(alpha: 0.06),
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(
          //       color: _syncEnabled
          //           ? Colors.green.withValues(alpha: 0.3)
          //           : Colors.grey.withValues(alpha: 0.2),
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       Container(
          //         width: 10,
          //         height: 10,
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: _syncEnabled ? Colors.green : Colors.grey,
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               _syncEnabled ? 'Connected to Server' : 'Not Connected',
          //               style: TextStyle(
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.bold,
          //                 color: _syncEnabled ? Colors.green : Colors.grey,
          //               ),
          //             ),
          //             if (_lastSyncTime != null)
          //               Text(
          //                 'Last sync: ${_formatSyncTime(_lastSyncTime)}',
          //                 style: const TextStyle(
          //                   fontSize: 11,
          //                   color: Colors.grey,
          //                 ),
          //               ),
          //           ],
          //         ),
          //       ),
          //
          //       // sync toggle
          //       Row(
          //         children: [
          //           const Text(
          //             'Auto Sync',
          //             style: TextStyle(fontSize: 12, color: Colors.grey),
          //           ),
          //           const SizedBox(width: 8),
          //           Switch(
          //             value: _syncEnabled,
          //             activeColor: AppColors.primaryColor,
          //             onChanged: (val) async {
          //               String? baseurl = await ApiConfig.getBaseUrl();
          //               if (
          //                   baseurl.isEmpty||baseurl=="https://api.counterproapp.com/v1") {
          //                 AppUtil.toastMessage(
          //                   message: AppStrings
          //                       .pleaseOnlyCompaniesCanHaveAPIAccessandAPIKey,
          //                   context: context,
          //                     backgroundColor: AppColors.secondaryColor
          //                 );
          //               }else{
          //                 setState(() => _syncEnabled = val);
          //                 ApiConfig.setSyncEnabled(val);
          //               }
          //
          //             },
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 16),

          // ── API Settings ──────────────────────────────

          Row(
            children: [
              GuideCard(),
              SizedBox(width: 24,),
              Forms(
                apiKeyController: _apiKeyController,
               baseUrlController: _baseUrlController,
                isSaving: _isSaving,
                isValidating: _isValidating,
                validateApiKey:
                  _validateApiKey,
                saveSettings: _saveSettings,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Manual sync ───────────────────────────────
          SectionTitle(title: 'Manual Sync'),
          const SizedBox(height: 8),
          const Text(
            'Push your local data to the server and pull any updates.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: SyncCard(
                  title: 'Push to Server',
                  subtitle: 'Upload local data',
                  icon: Icons.cloud_upload_outlined,
                  color: AppColors.primaryColor,
                  isLoading: _isSyncing,
                  onTap: () =>
                      SyncService().syncAll(pushLocal: true, pullRemote: false, context: context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SyncCard(
                  title: 'Pull from Server',
                  subtitle: 'Download server data',
                  icon: Icons.cloud_download_outlined,
                  color: Colors.blue,
                  isLoading: _isSyncing,
                  onTap: () =>
                      SyncService().syncAll(pushLocal: false, pullRemote: true, context: context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SyncCard(
                  title: 'Full Sync',
                  subtitle: 'Push and pull',
                  icon: Icons.sync_outlined,
                  color: Colors.green,
                  isLoading: _isSyncing,
                  onTap: _syncNow,
                ),
              ),
            ],
          ),

          // ── Sync result ───────────────────────────────
          if (_lastResult != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _lastResult!.hasErrors
                    ? Colors.orange.withValues(alpha: 0.08)
                    : Colors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _lastResult!.hasErrors
                      ? Colors.orange.withValues(alpha: 0.3)
                      : Colors.green.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Sync Result',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _lastResult!.hasErrors
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ResultChip(
                        label: 'Pushed',
                        value: _lastResult!.pushed,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      ResultChip(
                        label: 'Pulled',
                        value: _lastResult!.pulled,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      ResultChip(
                        label: 'Failed',
                        value: _lastResult!.failed,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  if (_lastResult!.hasErrors) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Errors:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                    ..._lastResult!.errors
                        .take(5)
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '• $e',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                    if (_lastResult!.errors.length > 5)
                      Text(
                        '+ ${_lastResult!.errors.length - 5} more errors',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}





