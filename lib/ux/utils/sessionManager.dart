import 'package:eswaini_destop_app/platform/utils/isar_manager.dart';
import 'package:eswaini_destop_app/ux/models/shared/company.dart';
import 'package:eswaini_destop_app/ux/models/shared/pos_user.dart';
import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

class SessionManager {
  // singleton
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  // current logged in user
  PosUser? _currentUser;

  // current company
  Company? _company;

  // ── User getters ──────────────────────────────────────────
  PosUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  int? get userId => _currentUser?.id;
  String? get userName => _currentUser?.name;
  String? get userEmail => _currentUser?.email;
  String? get userPassword => _currentUser?.passwordHash;
  UserRole? get userRole => _currentUser?.role;
  bool get isAdmin => _currentUser?.role == UserRole.admin;
  bool get isManager => _currentUser?.role == UserRole.manager;
  bool get isCashier => _currentUser?.role == UserRole.cashier;

  // ── Company getters ───────────────────────────────────────
  Company? get company => _company;
  bool get hasCompany => _company != null;

  String? get companyName => _company?.name;
  String? get companyEmail => _company?.email;
  String? get companySlogan => _company?.slogan;
  String? get companyAddress => _company?.address;
  String? get companyContactOne => _company?.contactOne;
  String? get companyContactTwo => _company?.contactTwo;
  String? get companyLogoPath => _company?.logoPath;

  // ── Save user on login + fetch company ───────────────────
  Future<void> save(PosUser user , BuildContext context) async {
    _currentUser = user;
    await _loadCompany(context);
  }

  // ── Load company from Isar ────────────────────────────────
  Future<void> _loadCompany(BuildContext context) async {
    try {
      final isar = IsarService.db;
      _company = await isar.companys.where().findFirst();
    } catch (e) {
      print('❌ SessionManager: failed to load company — $e');
      _company = null;
      AppNavigator.gotoLogin(context: context);
      AppUtil.toastMessage(message: 'SessionManager: failed to load company — $e', context: context);
    }
  }

  // ── Refresh company data anytime ──────────────────────────
  Future<void> refreshCompany(BuildContext context) async {
    await _loadCompany(context);
  }

  // ── Clear everything on logout ────────────────────────────
  void clear() {
    _currentUser = null;
    _company = null;
  }
}