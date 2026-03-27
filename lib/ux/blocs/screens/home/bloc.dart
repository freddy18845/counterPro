import "dart:async";

import "package:eswaini_destop_app/ux/utils/sessionManager.dart";
import "package:eswaini_destop_app/ux/utils/shared/app.dart";
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
         if(SessionManager().isCashier){
           AppUtil.toastMessage(message: 'Sorry, Your Not Approve For This Feature.',
               backgroundColor: Colors.amber,
               context: sectionContext);
         } else{
           AppNavigator.gotoReports(
             context: sectionContext,
             data: event.item,
           );
         }

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
