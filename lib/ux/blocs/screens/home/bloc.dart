import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../models/screens/home/flow_item.dart";
import "../../../models/shared/transaction.dart";
import "../../../nav/app_navigator.dart";
import "../../../res/app_strings.dart";




part "event.dart";
part "state.dart";

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late BuildContext sectionContext;
  late StreamController<Map> bottomNavController;
  late StreamController<Map> baseSecSummaryController;
 late HomeFlowItem metaData ;

  HomeBloc() : super(HomeInitState()) {
    on<HomeBaseSecStartFlow>((event, emit) async {
      final flowText = event.item.text;
metaData = event.item;



      switch (flowText) {
        case AppStrings.inventory:
          AppNavigator.gotoInventory(
            context: sectionContext,
            data: event.item,
            onIsLowStock: null

          );
          break;

        case AppStrings.sales:
          AppNavigator.gotoSales(
            context: sectionContext,
            data: event.item,
          );
          break;
        case AppStrings.transactions:
          AppNavigator.gotoTransaction(
            context: sectionContext,
              data: event.item,

          );
          break;
        case AppStrings.reports:
          AppNavigator.gotoReports(
            context: sectionContext,
            data: event.item,
          );
          break;
          case AppStrings.savedSales:
          AppNavigator.gotoSalesOrder(
            context: sectionContext,
            data: event.item,

          );
          break;
        default:
          AppNavigator.gotoHome(TransactionData(),context: sectionContext);
      }
    });

    on<HomeSwitchTab>((event, emit) async {
      final activeIndex = event.activeTab;

      // switch (activeIndex) {
      //   case 1:
      //     AppNavigator.gotoTrans(
      //       context: sectionContext,
      //       range: AppUtil.getDateRange(
      //         filterRequest: TransactionsDateFilter.today,
      //       ),
      //     );
      //     break;
      //
      //   case 2:
      //     AppNavigator.gotoSettings(context: sectionContext);
      //     break;
      //   case 0:
      //     AppNavigator.gotoHome(context: sectionContext);
      //     break;
      //
      //   default:
      //     AppNavigator.gotoHome(context: sectionContext);
      // }
    });
    on<HomeLogoutEvent>((event, emit) {
      // AppNavigator.logout(
      //   context: sectionContext,
      // );
    });


  }

  void init({
    required BuildContext context,
  }) {
    sectionContext = context;
    bottomNavController = StreamController.broadcast();
    baseSecSummaryController = StreamController.broadcast();
  }

  void dispose() {
    bottomNavController.close();
    baseSecSummaryController.close();
  }
}
