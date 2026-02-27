import 'package:eswaini_destop_app/ux/models/screens/payment/payment_option.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:flutter/material.dart';
import '../../shared/wallet/network.dart';
import '../../terminal_sign_on_response.dart';

class HomeFlowItem {
  final String icon;
  final String text;
  late String senderAccount;
  late String beneficiaryAccount;
  late double amount;
  late Currency currency;
  final String trsType;
  final String msgType;
  final List<PaymentOption> paymentOption;

  late String pan;
  late bool forceSelectCurrency;
  late PaymentOption paymentType;
  late WalletNetwork walletNetwork;


  HomeFlowItem( {
    required this.icon,
    required this.text,
    required this.trsType,
    required this.msgType,
    required this.paymentOption,
    this.beneficiaryAccount = '',
    this.senderAccount = '',
    this.amount = 0,
    this.pan= '',
    this.forceSelectCurrency = false,
    PaymentOption? paymentType,
    WalletNetwork? walletNetwork,
    Currency? currency,
  }) : currency = currency ??
      Currency(
        code: '',
        name: '',
        alphaCode: '',
        symbol: '',
        precision: '',
        merchantID: '',
        terminalID: '',
        floorLimit: '',
        ceilingLimit: '',
        contactlessNoPinLimit: '',
        contactlessLimit: '',
        cashbackLimit: '',
      ),
        paymentType = paymentType ??
            PaymentOption(
              label: '',
              tenderType: '',
              icon: '',
              description: '',
            ),
        walletNetwork = walletNetwork ??
            WalletNetwork(
              id: "001",
              name: '',
              image: '',
              outLineColor:Colors.transparent,
              requiresVerification: false,
            );
}