import 'package:flutter/material.dart';
import '../../ux/res/app_drawables.dart';

Future<void> precacheAppImages(BuildContext context) async {
  // Precache raster images (PNG, JPG, GIF)
  final rasterImages = [
    AppDrawables.loadingScreen,
    AppDrawables.banner,
    AppDrawables.pinPad,
    AppDrawables.receipt,
    AppDrawables.orangeCard,
    AppDrawables.greyCard,
    AppDrawables.blueCard,
    AppDrawables.greenCard,
    AppDrawables.redCard,
    AppDrawables.successImage,
    AppDrawables.visaImage,
    AppDrawables.bannerOne,
    AppDrawables.bannerTwo,
    AppDrawables.progressCard,
    AppDrawables.greenLoadingGif,
    AppDrawables.mtn,
    AppDrawables.shareSha,
    AppDrawables.eMali,
  ];

  for (final imagePath in rasterImages) {
    await precacheImage(
      AssetImage(imagePath),
      context,
      onError: (exception, stackTrace) {
        debugPrint('❌ Failed to precache raster image $imagePath: $exception');
      },
    );
  }

  // Precache SVG images
  final svgImages = [
    AppDrawables.logoSVG,
    AppDrawables.darkLogoSVG,
    AppDrawables.fingerPrintSVG,
    AppDrawables.faceIDSVG,
    AppDrawables.emptyReceiptSVG,
    AppDrawables.moneySVG,
    AppDrawables.settingsSVG,
    AppDrawables.rateSVG,
    AppDrawables.logoSVG,
    AppDrawables.logoutSVG,
    AppDrawables.dateSVG,
    AppDrawables.arrowDownSVG,
    AppDrawables.arrowUpSVG,
    AppDrawables.profileSVG,
    AppDrawables.globeSVG,
    AppDrawables.clearSVG,
    AppDrawables.walletSVG,
    AppDrawables.inventorySVG,
    AppDrawables.salesSVG,
    AppDrawables.transactionSVG,
    AppDrawables.phoneSVG,
    AppDrawables.whatsappSVG,
    AppDrawables.cardSVG,
    AppDrawables.transactionSVG,
    AppDrawables.savedSalesSVG,
    AppDrawables.homeSVG,
    AppDrawables.reportSVG,
  ];

  for (final svgPath in svgImages) {
    precacheImage(
      AssetImage(svgPath),
      context,
      onError: (exception, stackTrace) {
        debugPrint('Failed to precache image $svgPath: $exception');
      },
    );
  }

  debugPrint('✅ All app images precached successfully!');
}
