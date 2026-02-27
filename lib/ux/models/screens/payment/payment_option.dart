import '../../../res/app_colors.dart';
import '../../shared/wallet/network.dart';

class PaymentOption {
  String label;
  String tenderType;
  String icon;
  String description;
  late WalletNetwork walletPayment;

  PaymentOption({
    required this.label,
    required this.tenderType,
    required this.icon,
    required this.description,
    WalletNetwork? walletPayment,
  }) : walletPayment =
           walletPayment ??
           WalletNetwork(
             id: "",
             name: '',
             image: '',
             outLineColor: AppColors.primaryColor,
             requiresVerification: false,
           );
}
