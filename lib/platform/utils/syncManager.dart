
import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../ux/utils/shared/api_config.dart';
import '../../ux/views/fragements/configSetting/sync_service.dart';


class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;
  SyncManager._internal();

  Timer? _timer;
  static const _interval = Duration(minutes: 15);

  // ── Start auto sync timer ─────────────────────────────────
  void startAutoSync(BuildContext context) {
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) async {
      final enabled = await ApiConfig.isSyncEnabled();
      if (enabled && !SyncService().isSyncing) {
        debugPrint('⏰ Auto sync triggered');
        await SyncService().syncAll(context: context);
      }
    });
    debugPrint('✅ Auto sync started — every 15 min');
  }

  // ── Stop auto sync ────────────────────────────────────────
  void stopAutoSync() {
    _timer?.cancel();
    _timer = null;
    debugPrint('⏹ Auto sync stopped');
  }

  // ── Sync immediately then start timer ─────────────────────
  Future<void> initAndSync( BuildContext context) async {
    final enabled = await ApiConfig.isSyncEnabled();
    if (!enabled) return;

    // sync now immediately
    await SyncService().syncAll( context: context);

    // then keep syncing every 15 min
    startAutoSync(context);
  }
}