
import "package:eswaini_destop_app/ux/models/terminal_sign_on_response.dart";
import "package:eswaini_destop_app/ux/res/app_colors.dart";
import "package:flutter/material.dart";

import "../../ux/models/screens/home/flow_item.dart";
import "../../ux/models/screens/payment/payment_option.dart";
import "../../ux/models/shared/wallet/network.dart";
import "../../ux/res/app_drawables.dart";
import "../../ux/res/app_strings.dart";

import "../../ux/utils/shared/screen.dart";


class ConstantUtil {
  ConstantUtil._();

  static const String appName = "Eswatini Desktop App v1.0.0";
  static const String appDesc = "Your All In One Mobile POS Application ";
  static const String appVersion = "v1.0.0";
  static const String appExpiry = "2028-12-31 23:59:59";
  static const bool appBuildIsDebug = true;
  static bool isSunmiPrinter = false;
  //static  String defaultUrl = "http://172.60.254.12:8080/PayAPI/";
  static String defaultUrl = "http://172.60.254.98:9090";
  //static  String defaultUrl = "http://localhost:9090";
  static const String country = "Swaziland";
  static const String deviceID = "96752f2ce97ccfc3";
  static const String deviceSerialID = "96752f2ce97ccfc3";
  static const int countryCode = 716;
  static const String acquiringNetworkID = '716001';
  static const String terminalType = '21';
  static const double maxHeightBtn = 80;
  static const double maxOtpHeight = 40.0;
  static const double loginInputWidth = 350;
  static const double maxReceiptCardWidth = 350;
  static double verticalSpacing = (ScreenUtil.height * 0.02).clamp(8, 16);
  static double horizontalSpacing = (ScreenUtil.width * 0.014).clamp(8, 16);

  static const double maxWidthBtnAppBar = 250;
  static const double maxWidthAllowed = 1366.0;
  // static const double maxHeightAllowed =(10020.0);
  static const double maxHeightAllowed = (768.0 - maxHeightAppBar);
  static const double maxHeightAppBar = 60.0;
  static const double mixHeightBtn = 58;
  static const double btnBottomPadding = 40;
  static const double dropDownItem = 60;
  static const int apiTimeDuration = 120;
  static const String receiptContact = "78025000";
  static const String fontFamily = "SF Pro Rounded";
  static const String defaultMerchantName = "Test One";
  static const String defaultBusinessID = "2025010001";
  static const String defaultMerchantLocation = "Harare, Zimbabwe";
  static const String activatorPsd = '112233';
  static const String activatorUsername = 'Admin';
  static List<HomeFlowItem> options = [
    HomeFlowItem(
      icon: AppDrawables.withdrawalSVG,
      text: AppStrings.withdrawal,
      trsType: '00',
      msgType: '0200',
       paymentOption: [
         ConstantUtil.paymentOptions[0],
         ConstantUtil.paymentOptions[1],
         ConstantUtil.paymentOptions[2],
         ConstantUtil.paymentOptions[3],
       ]


    ),
    HomeFlowItem(
      icon: AppDrawables.depositSVG,
      text: AppStrings.deposit,
      trsType: '09',
      msgType: '0200',
        paymentOption: [
          ConstantUtil.paymentOptions[0],
          ConstantUtil.paymentOptions[1],
          ConstantUtil.paymentOptions[2],
          ConstantUtil.paymentOptions[5],
        ]
    ),
    HomeFlowItem(
      icon: AppDrawables.transfersSVG,
      text: AppStrings.transfer,
      trsType: '54',
      msgType: '0400',
        paymentOption: [
          ConstantUtil.paymentOptions[0],
          ConstantUtil.paymentOptions[1],
          ConstantUtil.paymentOptions[2],
          ConstantUtil.paymentOptions[3],
        ]
    ),

    HomeFlowItem(
      icon: AppDrawables.mobileWalletSVG,
      text: AppStrings.payment,
      trsType: '54',
      msgType: '0400',
        paymentOption: [
          ConstantUtil.paymentOptions[0],
          ConstantUtil.paymentOptions[1],
          ConstantUtil.paymentOptions[2],
          ConstantUtil.paymentOptions[3],
        ]
    ),HomeFlowItem(
      icon: AppDrawables.transactionSVG,
      text: AppStrings.transactions,
      trsType: '54',
      msgType: '0400',
        paymentOption: [
          ConstantUtil.paymentOptions[0],
          ConstantUtil.paymentOptions[1],
          ConstantUtil.paymentOptions[2],
          ConstantUtil.paymentOptions[3],
        ]
    ),
  ];

  static List<WalletNetwork> networks = [
    WalletNetwork(
        id: "001",
        name: AppStrings.shareSha,
        image: AppDrawables.shareSha,
        outLineColor: AppColors.primaryColor,
        requiresVerification: false,
       ),
    WalletNetwork(
        id: "002",
        name: AppStrings.eMali,
        image: AppDrawables.eMali,
        outLineColor: AppColors.red,
        requiresVerification: false,
       ), WalletNetwork(
        id: "001",
        name:AppStrings.mtn,
        image: AppDrawables.mtn,
        outLineColor: Colors.white,
        requiresVerification: false,
       ),

  ];
  static List<PaymentOption> paymentOptions = [
    PaymentOption(
      label: AppStrings.card,
      icon: AppDrawables.cardSVG,
      tenderType: AppStrings.tenderTypeCard,
      description: AppStrings.cardPayment,
    ),
    PaymentOption(
      label: AppStrings.account,
      icon: AppDrawables.accountPaySVG,
      tenderType: AppStrings.tenderTypeAccount,
      description: AppStrings.accountTransfer,
    ),
    PaymentOption(
      label: AppStrings.wallet,
      icon: AppDrawables.mobileWalletSVG,
      tenderType: AppStrings.tenderTypeWallet,
      description: AppStrings.digitalWallet,
    ),
    PaymentOption(
      label: AppStrings.p2p,
      icon: AppDrawables.p2pPaySVG,
      tenderType: AppStrings.tenderTypeP2p,
      description: AppStrings.p2pDescription,
    ),
    PaymentOption(
      label: AppStrings.deposit,
      icon: AppDrawables.depositSVG,
      tenderType: AppStrings.tenderTypeP2p,
      description: '',
    ),
    PaymentOption(
      label: AppStrings.cheque,
      icon: AppDrawables.chequeSVG,
      tenderType: AppStrings.tenderTypeP2p,
      description: AppStrings.p2pDescription,
    ),
  ];


  static // Eswatini Currencies List
  final List<Currency> eswatiniCurrencies = [
    Currency(
      code: "748",
      name: "Eswatini Lilangeni",
      alphaCode: "SZL",
      symbol: "E",
      precision: "2",
      merchantID: "M7480000001CCY1",
      terminalID: "TID43200",
      floorLimit: "0.00",
      ceilingLimit: "800000000.00",
      contactlessNoPinLimit: "200.00",
      contactlessLimit: "600.00",
      cashbackLimit: "250.00",
    ),
    Currency(
      code: "710",
      name: "South African Rand",
      alphaCode: "ZAR",
      symbol: "R",
      precision: "2",
      merchantID: "M7100000001CCY2",
      terminalID: "TID43210",
      floorLimit: "0.00",
      ceilingLimit: "5000.00",
      contactlessNoPinLimit: "1000.00",
      contactlessLimit: "2000.00",
      cashbackLimit: "100.00",
    ),
  ];

  // Zimbabwe Currencies List

}
