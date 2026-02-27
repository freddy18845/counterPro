import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../models/screens/home/flow_item.dart";
import "../../../nav/app_navigator.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/app.dart";



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
metaData.amount =0;
metaData.beneficiaryAccount ='';
metaData.senderAccount ='';


      switch (flowText) {
        case AppStrings.withdrawal:
          AppNavigator.gotoWithdrawal(
            context: sectionContext,
            data: event.item,
            summaryController: baseSecSummaryController,
          );
          break;

        // case AppStrings.payment:
        //   AppNavigator.gotoAmount(
        //     context: sectionContext,
        //     flowInfo: event.item,
        //     summaryController: baseSecSummaryController,
        //   );
        //   break;
        // case AppStrings.void_:
        //   AppNavigator.gotoVoid(
        //     context: sectionContext,
        //     flowInfo: event.item,
        //     summaryController: baseSecSummaryController,
        //   );
        //   break;
        // case AppStrings.saleCash:
        //   AppNavigator.gotoCashback(
        //     context: sectionContext,
        //     flowInfo: event.item,
        //     summaryController: baseSecSummaryController,
        //   );
          break;
        default:
          AppNavigator.gotoHome(context: sectionContext);
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
