import 'dart:async';
import 'package:eswaini_destop_app/ux/blocs/screens/home/bloc.dart';
import 'package:eswaini_destop_app/ux/models/screens/home/flow_item.dart';
import 'package:eswaini_destop_app/ux/models/shared/transaction.dart';
import 'package:eswaini_destop_app/ux/views/screens/home.dart';
import 'package:eswaini_destop_app/ux/views/screens/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../blocs/screens/login/bloc.dart';
import '../blocs/screens/splash/bloc.dart';
import '../views/screens/config_settings.dart';
import '../views/screens/login.dart';
import '../views/screens/inventory.dart';
import '../views/screens/sales.dart';
import '../views/screens/saved_orders.dart';
import '../views/screens/setUp.dart';
import '../views/screens/transactions.dart';

class AppNavigator {
  static const String login = "login";
  static const String home = "home";
  static const String inventory = "inventory";
  static const String sales = "sales";
  static const String salesOrder = "salesOrder";
  static const String reports = "reports";
  static const String transaction = "transaction";
  static const String configSettings = "configSettings";
  static const String setUP = "setUp";
  AppNavigator._();

  // Helper to merge blocs (kept your logic)
  static List<BlocProvider> _mergeBlocs({
    required BuildContext context,
    required List<dynamic> newBlocs,
  }) {
    return newBlocs.map((e) {
      if (e is BlocProvider) return e;
      return e(context) as BlocProvider;
    }).toList();
  }

  // Updated _pushNav - handles empty bloc list safely
  static Future<void> _pushNav({
    required BuildContext context,
    required List<dynamic> newBlocs,
    required Widget screen,
    required String routId,
  }) async {
    final Widget child;

    if (newBlocs.isEmpty) {
      // No blocs needed → push screen directly (no MultiBlocProvider)
      child = screen;
    } else {
      // Blocs present → wrap with MultiBlocProvider
      child = MultiBlocProvider(
        providers: _mergeBlocs(context: context, newBlocs: newBlocs),
        child: screen,
      );
    }

    await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 400),
        alignment: Alignment.center,
        settings: RouteSettings(name: routId),
        child: child,
      ),
    );
  }

  // ── Navigation Methods ─────────────────────────────────────────────────────

  static Future gotoLogin({required BuildContext context}) => _pushNav(
    context: context,
    newBlocs: [
      (context) => BlocProvider<LoginBloc>(create: (_) => LoginBloc()),
    ],
    screen: const LoginScreen(),
    routId: login,
  );

  static Future gotoHome(
    TransactionData data, {
    required BuildContext context,
  }) => _pushNav(
    context: context,
    newBlocs: [
      (context) => BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
    ],
    screen: HomeScreen(transactionData: data),
    routId: home,
  );

  static Future gotoInventory({
    required BuildContext context,
    required HomeFlowItem data,
  required Function(StockFilter)? onIsLowStock
  }) => _pushNav(
    context: context,
    newBlocs: [], // Empty is now safe
    screen: InventoryScreen(
      isLowStock:onIsLowStock ,
        selectedTransaction: data),
    routId: inventory,
  );

  static Future gotoSales({
    required BuildContext context,
    required HomeFlowItem data,
  }) => _pushNav(
    context: context,
    newBlocs: [], // Empty is now safe
    screen: SalesScreen(
      selectedTransaction: data, // if needed
    ),
    routId: sales,
  );

  static Future gotoSalesOrder({
    required BuildContext context,
    required HomeFlowItem data,
  }) => _pushNav(
    context: context,
    newBlocs: [],
    screen: SavedOrdersScreen(selectedTransaction: data),
    routId: salesOrder,
  );

  static Future gotoTransaction({
    required BuildContext context,
    required HomeFlowItem data,
  }) => _pushNav(
    context: context,
    newBlocs: [],
    screen: TransactionsScreen(selectedTransaction: data),
    routId: transaction,
  );

  static Future gotoSetUp({required BuildContext context}) => _pushNav(
    context: context,
    newBlocs: [
      (context) => BlocProvider<SplashBloc>(create: (_) => SplashBloc()),
    ],
    screen: const SetUPScreen(),
    routId: setUP,
  );

  static Future gotoReports({
    required BuildContext context,
    required HomeFlowItem data,
  }) => _pushNav(
    context: context,
    newBlocs: [],
    screen: ReportScreen(selectedTransaction: data),
    routId: reports,
  );



  static Future gotoConfigSettings({required BuildContext context}) => _pushNav(
    context: context,
    newBlocs: [],
    screen: const SystemConfigScreen(),
    routId: configSettings,
  );
}
