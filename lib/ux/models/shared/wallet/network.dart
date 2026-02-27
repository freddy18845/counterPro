import 'dart:ui';

import '../../../res/app_colors.dart';

class WalletNetwork {

  String id;
  String name;
  String image;
  Color outLineColor;
  bool requiresVerification;
  WalletNetwork({
    this.id = "",
    this.name = "",
    this.image = "",
    this.outLineColor =AppColors.primaryColor,
    this.requiresVerification = false,
  });

}
