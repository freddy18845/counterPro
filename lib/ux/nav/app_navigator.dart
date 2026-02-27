import 'dart:async';

import 'package:eswaini_destop_app/ux/blocs/screens/home/bloc.dart';
import 'package:eswaini_destop_app/ux/blocs/shared/wallet/bloc.dart';
import 'package:eswaini_destop_app/ux/models/screens/home/flow_item.dart';
import 'package:eswaini_destop_app/ux/views/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../blocs/screens/login/bloc.dart';
import '../blocs/screens/withdrawal/bloc.dart';
import '../blocs/shared/p2p/bloc.dart';
import '../blocs/shared/preview/bloc.dart';
import '../blocs/shared/processing/bloc.dart';
import '../blocs/shared/account/bloc.dart';
import '../views/screens/login.dart';
import '../views/screens/withdrawal.dart';

class AppNavigator {
  static const String login = "login";
  static const String home = "home";
  static const String withdrawal = "withdrawal";
  static const String configSettings = "configSettings";

  AppNavigator._();

  // FIX: Added the missing _mergeBlocs method
  static List<BlocProvider> _mergeBlocs({
    required BuildContext context,
    required List<dynamic> newBlocs,
  }) {
    // This allows you to pass both BlocProvider objects
    // and custom creators if your project uses them.
    return newBlocs.map((e) {
      if (e is BlocProvider) return e;
      return e(context) as BlocProvider;
    }).toList();
  }

  static Future _pushNav({
    required BuildContext context,
    required List<dynamic> newBlocs,
    required Widget screen,
    required String routId,
  }) => Navigator.push(
    context,
    PageTransition(
      // REPLACED MaterialPageRoute
      type: PageTransitionType
          .fade, // You can change this to rightToLeft, bottomToTop, etc.
      duration: const Duration(milliseconds: 400),
      alignment: Alignment.center,
      settings: RouteSettings(name: routId),
      child: MultiBlocProvider(
        providers: _mergeBlocs(context: context, newBlocs: newBlocs),
        child: screen,
      ),
    ),
  );

  static Future gotoLogin({required BuildContext context}) => _pushNav(
    context: context,
    newBlocs: [
      (context) => BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
    ],
    screen: const LoginScreen(),
    routId: login,
  );
  static Future gotoHome({required BuildContext context}) => _pushNav(
    context: context,
    newBlocs: [
      (context) => BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
      (context) =>
          BlocProvider<PreviewBloc>(create: (context) => PreviewBloc()),
      (context) =>
          BlocProvider<ProcessingBloc>(create: (context) => ProcessingBloc()),
    ],
    screen: const HomeScreen(),
    routId: home,
  );

  static Future gotoWithdrawal({
    required BuildContext context,
    required StreamController<Map> summaryController,
    required HomeFlowItem data,
  }) => _pushNav(
    context: context,
    newBlocs: [
      (context) => BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
      (context) =>
          BlocProvider<PreviewBloc>(create: (context) => PreviewBloc()),

      (context) => BlocProvider<WalletBloc>(create: (context) => WalletBloc()),
      (context) =>
          BlocProvider<AccountBloc>(create: (context) => AccountBloc()),
          (context) =>
          BlocProvider<P2PBloc>(create: (context) => P2PBloc()),
      (context) =>
          BlocProvider<WithdrawalBloc>(create: (context) => WithdrawalBloc()),
      (context) =>
          BlocProvider<ProcessingBloc>(create: (context) => ProcessingBloc()),
    ],
    screen: WithdrawalScreen(
      selectedTransaction: data,
      refreshController: summaryController,
    ),
    routId: withdrawal,
  );

  // static Future gotoConfigSettings({required BuildContext context}) =>
  //     _pushNav(
  //       context: context,
  //       newBlocs: [], // Pass empty list if no new blocs are needed
  //       screen: const ConfigSettingsScreen(),
  //       routId: configSettings,
  //     );
}
