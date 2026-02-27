import "dart:async";
import "package:eswaini_destop_app/ux/models/screens/payment/payment_option.dart";
import "package:eswaini_destop_app/ux/models/shared/wallet/network.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../Providers/transaction_provider.dart";
import "../../../enums/screens/payment/flow_step.dart";
import "../../../models/screens/home/flow_item.dart";
import "../../../models/terminal_sign_on_response.dart";
import "../../../nav/app_navigator.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/app.dart";
import "../../../views/components/dialogs/currency.dart";
import "../../../views/components/dialogs/netWorks.dart";
import "../../screens/home/bloc.dart";
import "event.dart";

part "state.dart";

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  bool busyState = false;
  late HomeFlowItem metaData;
  late BuildContext sectionContext;
  late HomeBloc homeBloc;


  StreamController<Map>? fieldController;
  StreamController<Map>? submitController;
  StreamController<Map>? subSectionController;

  final transactionManager = TransactionManager();

  WalletBloc() : super(WalletInitialState()) {

    // Go back event handler
    on<WalletGoBackEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }


    });

    // Exit event handler
    on<WalletExitEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }



      subSectionController?.add({"exit": true});
    });



    // Prompt currency selection
    on<WalletNetworkPromptEvent>((event, emit) async {
      List<Currency> currencies = await transactionManager.getCurrencies();

      if (currencies.isEmpty) return;

      if (currencies.length <= 1) {
        metaData.currency = currencies[0];
      } else {
        metaData.currency ??= currencies.first;

        Currency? res = await AppUtil.displayDialog(
          dismissible: false,
          context: sectionContext,
          child: NetworkDialog(),
        );

        if (!sectionContext.mounted) return;

        if ((metaData.currency == null) && (res == null)) {
          Navigator.pop(sectionContext);
          return;
        }

        metaData.currency = res!;
        metaData.forceSelectCurrency = true;
        transactionManager.setActiveCurrency(res);
      }

      emit(WalletCurrencySelectedState(currency: metaData.currency!));
    });

    // Set currency event





    // Set payment type event
    on<WalletSetNetWorkTypeEvent>((event, emit) async {
      if (metaData.amount < 0 || metaData.amount == 0) {
        AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.kindlyEnterAmountFirst,
        );
        return;
      }
      metaData.paymentType = event.paymentType;
      if(metaData.paymentType.label==AppStrings.wallet) {
        WalletNetwork? res = await AppUtil.displayDialog(
          dismissible: false,
          context: sectionContext,
          child: NetworkDialog(),
        );
       if(res != null ) {
         metaData.paymentType.walletPayment = res;
       }
      }

      emit(WalletPaymentMethodSelectedState(paymentType: event.paymentType));
    });



  }

  void init({
    required BuildContext context,
    required HomeFlowItem data,
   // required StreamController<Map> refreshController,
  }) {
    sectionContext = context;
    metaData = data;
    // submitController = StreamController.broadcast();
    // fieldController = StreamController.broadcast();
    // subSectionController = StreamController.broadcast();
    emit(WalletInitialState());
  }

  void dispose() {
    // submitController?.close();
    // fieldController?.close();
    // subSectionController?.close();
  }
}