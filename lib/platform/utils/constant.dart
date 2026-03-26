import "../../ux/models/screens/home/flow_item.dart";
import "../../ux/res/app_drawables.dart";
import "../../ux/res/app_strings.dart";
import "../../ux/utils/shared/screen.dart";

class ConstantUtil {
  ConstantUtil._();

  static const String appName = "Counter Pro App";
  static const String appDesc = "Your Number One Point Of Sales Solution ";
  static const String appVersion = "v1.0.0";
  static const String currencySymbol = 'Gh₵';
  static const double maxHeightBtn = 50;
  static const double maxOtpHeight = 40.0;
  static const double loginInputWidth = 380;
  static const double maxReceiptCardWidth = 350;
  static double verticalSpacing = (ScreenUtil.height * 0.025);
  static double horizontalSpacing = (ScreenUtil.width * 0.016);

  static const double maxWidthBtnAppBar = 250;
  static const double maxWidthAllowed = 1366.0;
  static double maxHeightAllowed = (ScreenUtil.height * 0.07);
  static const double maxHeightAppBar = 60.0;
  static const double mixHeightBtn = 58;
  static const double btnBottomPadding = 40;
  static const double dropDownItem = 60;
  static const int apiTimeDuration = 120;

  static List<HomeFlowItem> options = [
    HomeFlowItem(icon: AppDrawables.inventorySVG, text: AppStrings.inventory),
    HomeFlowItem(icon: AppDrawables.salesSVG, text: AppStrings.sales),

    HomeFlowItem(icon: AppDrawables.savedSalesSVG, text: AppStrings.savedSales),
    HomeFlowItem(
      icon: AppDrawables.transactionSVG,
      text: AppStrings.transactions,
    ),
    HomeFlowItem(icon: AppDrawables.reportSVG, text: AppStrings.reports),
  ];
}
