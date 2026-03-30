import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res/app_drawables.dart';
import '../../../utils/sessionManager.dart';

Widget buildCompanyLogo() {
  final logoPath = SessionManager().companyLogoPath;
  const double logoWidth = 130;
  const double logoHeight = 50;

  // 1. Fallback to SVG if null or empty
  if (logoPath == null || logoPath.isEmpty) {
    return  SvgPicture.asset(
      AppDrawables.darkLogoSVG,
      width: logoWidth,
      height: logoHeight,
      fit: BoxFit.fill,
    );
  }

  // 2. Handle Network Image
  if (logoPath.startsWith('http') || logoPath.startsWith('https')) {
    return Image.network(
      logoPath,
      width: logoWidth,
      height: logoHeight,
      fit: BoxFit.fill,
    );
  }

  // 3. Handle Local File Path
  final cleanPath = logoPath.replaceAll("file://", "");
  return Image.file(
    File(cleanPath),
    width: logoWidth,
    height: logoHeight,
    fit: BoxFit.fill,
  );
}