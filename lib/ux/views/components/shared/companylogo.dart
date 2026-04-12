import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res/app_drawables.dart';
import '../../../utils/sessionManager.dart';

Widget buildCompanyLogo() {
  final logoPath = SessionManager().companyLogoPath;
  const double logoWidth = 130;
  const double logoHeight = 50;

  Widget _fallbackLogo() => RepaintBoundary(
    child: SvgPicture.asset(
      AppDrawables.darkLogoSVG,
      width: logoWidth,
      height: logoHeight,
      fit: BoxFit.contain,
    ),
  );

  // 1. Fallback
  if (logoPath == null || logoPath.isEmpty) {
    return _fallbackLogo();
  }

  // 2. Network
  if (logoPath.startsWith('http')) {
    return Image.network(
      logoPath,
      width: logoWidth,
      height: logoHeight,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _fallbackLogo(),
      loadingBuilder: (context, child, progress) =>
      progress == null ? child : const CupertinoActivityIndicator(),
    );
  }

  // 3. Local File
  final cleanPath = logoPath.replaceFirst('file://', '');
  final file = File(cleanPath);

  return Image.file(
    file,
    width: logoWidth,
    height: logoHeight,
    fit: BoxFit.contain,
    cacheWidth: 200,
    cacheHeight: 200,
    filterQuality: FilterQuality.low,
    errorBuilder: (_, __, ___) => _fallbackLogo(),
  );
}