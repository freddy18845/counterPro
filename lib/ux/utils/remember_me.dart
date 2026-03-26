import 'package:isar/isar.dart';
import '../../platform/utils/isar_manager.dart';
import '../models/shared/remember_me_entity.dart' hide IsarService;

class RememberMeManager {
  static final RememberMeManager _instance =
  RememberMeManager._internal();

  factory RememberMeManager() => _instance;

  RememberMeManager._internal();

  final Isar _isar = IsarService.db;

  RememberMeEntity? _cache;

  // ── Load ─────────────────────────────
  Future<void> load() async {
    _cache = await _isar.rememberMeEntitys.get(1);
  }

  // ── Getters ──────────────────────────
  String? get savedEmail => _cache?.email;
  String? get savedPassword => _cache?.password;
  bool get rememberMe => _cache?.rememberMe ?? false;

  bool get hasSavedCredentials =>
      rememberMe &&
          savedEmail != null &&
          savedPassword != null;

  // ── Save ─────────────────────────────
  Future<void> save({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final entity = RememberMeEntity()
      ..id = 1
      ..email = rememberMe ? email : null
      ..password = rememberMe ? password : null
      ..rememberMe = rememberMe;

    await _isar.writeTxn(() async {
      await _isar.rememberMeEntitys.put(entity);
    });

    _cache = entity;
  }

  // ── Update Password ──────────────────
  Future<void> updatePassword(String newPassword) async {
    if (!rememberMe) return;

    final entity = _cache ?? RememberMeEntity()..id = 1;

    entity.password = newPassword;

    await _isar.writeTxn(() async {
      await _isar.rememberMeEntitys.put(entity);
    });

    _cache = entity;
  }

  // ── Clear ────────────────────────────
  Future<void> clear() async {
    await _isar.writeTxn(() async {
      await _isar.rememberMeEntitys.delete(1);
    });

    _cache = null;
  }
}