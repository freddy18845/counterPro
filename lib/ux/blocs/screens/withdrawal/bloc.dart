import "dart:async";
import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../Providers/transaction_provider.dart";
import "../../../enums/screens/payment/flow_step.dart";
import "../../../enums/shared/progress/action.dart";
import "../../../models/screens/home/flow_item.dart";
import "../../../models/shared/transaction.dart";
import "../../../models/shared/wallet/network.dart";
import "../../../models/terminal_sign_on_response.dart";
import "../../../nav/app_navigator.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/app.dart";
import "../../../views/components/dialogs/currency.dart";
import "../../../views/components/dialogs/netWorks.dart";
import "../../screens/home/bloc.dart";
import "event.dart";

part "state.dart";

class WithdrawalBloc extends Bloc<WithdrawalEvent, WithdrawalState> {
  //final String _tag = "WithdrawalBloc";
  bool busyState = false;
  late HomeFlowItem metaData;
  late BuildContext sectionContext;
  late HomeBloc homeBloc;
  GeneralTransactionFlowStep activeStep = GeneralTransactionFlowStep.enterAmount;
  StreamController<Map>? fieldController;
  StreamController<Map>? submitController;
  StreamController<Map>? subSectionController;

  final transactionManager = TransactionManager();
  WithdrawalBloc() : super(WithdrawalEnterAmountState()) {
    on<WithdrawalGoBackEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }
      if (activeStep == GeneralTransactionFlowStep.enterAmount) {
        return Navigator.pop(sectionContext);
      }

      final fieldData = {"set_amount": metaData.amount};
      fieldController?.add(fieldData);
      submitController?.add({"update_state": metaData.amount > 0});
      subSectionController?.add({"go_back": true});
    });

    on<WithdrawalExitEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }

      if (activeStep == GeneralTransactionFlowStep.enterAmount) {
        AppNavigator.gotoHome(context: sectionContext);

      }else if(activeStep == GeneralTransactionFlowStep.payment){
        emit(WithdrawalEnterAmountState());
      }


    });

    on<WithdrawalPromptCurrencyEvent>((event, emit) async {
      List<Currency> currencies = (await transactionManager.getCurrencies());
      if (currencies.isEmpty) return; // Safety check
      if (currencies.length <= 1) {
        metaData.currency = currencies[0];
      } else {
        // Set default currency if null
        metaData.currency ??= currencies.first;

        Currency? res = await AppUtil.displayDialog(
          dismissible: false,
          context: sectionContext,
          child: CurrencyDialog(
            selectedCurrency: metaData.currency, // Now safe to use !
          ),
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
      emit(WithdrawalEnterAmountState());
    });

    on<WithdrawalSetCurrencyEvent>((event, emit) async {
      List<Currency> currencies = (await transactionManager.getCurrencies());
      if (currencies.length <= 1) {
        metaData.currency = currencies[0];
      } else {
        metaData.currency = event.data!;
        metaData.forceSelectCurrency = true;
      }
      // emit(WithdrawalEnterAmountState());
    });

    on<WithdrawalSetAmountEvent>((event, emit) {
      metaData.amount = event.amount;

      final fieldData = {"set_amount": event.amount};
      fieldController?.add(fieldData);
      submitController?.add({"update_state": event.amount > 0});
      activeStep = GeneralTransactionFlowStep.payment;
      emit(WithdrawalEnterAmountState());
    });

    on<WithdrawalWalletSelectedEvent>((event, emit) {
      metaData.walletNetwork = event.network;
      emit(WithdrawalSelectedWalletState(data: metaData.walletNetwork));
    });

    on<WithdrawalSetPaymentTypeEvent>((event, emit) async {
      if (metaData.amount < 0 || metaData.amount == 0) {
        AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.kindlyEnterAmountFirst,
        );
        return;
      }
      metaData.paymentType = event.selectedPaymentOption;
     if(metaData.paymentType.label == AppStrings.wallet){
       WalletNetwork? net = await AppUtil.displayDialog(
         dismissible: false,
         context: sectionContext,
         child: NetworkDialog(),
       );
       if (net != null) {
         metaData.walletNetwork = net ;
         add(WithdrawalWalletSelectedEvent(network: metaData.walletNetwork));
       }
     } else if (metaData.paymentType.label == AppStrings.account){
       emit(WithdrawalPaymentMethodAccountState());
     }
     else if(metaData.paymentType.label == AppStrings.card){
       emit(WithdrawalPaymentMethodSelectedState());
     }
     else if(metaData.paymentType.label == AppStrings.p2p){
       emit(WithdrawalPaymentMethodP2PState());
     }
    });

    // on<WithdrawalSetWithdrawalTypeEvent>((event, emit) async {
    //  // metaData.WithdrawalType = event.type;
    //   final currency = await transactionManager.getCurrency();
    //   if (currency != null) {
    //     metaData.currency = currency;
    //   }
    //
    //   if (metaData.WithdrawalType == SaleWithdrawalType.card) {
    //     metaData.resCode36Retried = false;
    //   }
    //   emit(WithdrawalWithdrawalOptionState());
    // });

    // on<WithdrawalCardFlowResEvent>((event, emit) {
    //   if (event.data == null) return emit(WithdrawalEnterAmountState());
    //   if ((event.data?.error ?? "").isNotEmpty) {
    //     AppUtil.toastMessage(message: event.data?.error ?? "");
    //     return emit(WithdrawalEnterAmountState());
    //   }
    //   metaData.cardInfo = event.data;
    //   emit(WithdrawalSubmitTransactionState());
    // });

    on<WithdrawalProgressResEvent>((event, emit) {
      metaData = event.data;
      emit(WithdrawalPaymentMethodSelectedState());
    });
  }

  void init({
    required BuildContext context,
    required HomeFlowItem data,
    required StreamController<Map> refreshController,
  }) {
    sectionContext = context;
    metaData = data;
    submitController = StreamController.broadcast();
    fieldController = StreamController.broadcast();
    subSectionController = StreamController.broadcast();
    emit(WithdrawalEnterAmountState());
  }

  void dispose() {
    submitController?.close();
    fieldController?.close();
    subSectionController?.close();
  }
}
