import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../Providers/transaction_provider.dart";
import "../../../models/screens/home/flow_item.dart";
import "../../../nav/app_navigator.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/app.dart";
import "event.dart";

part "state.dart";

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  bool busyState = false;
  late HomeFlowItem metaData;
  late BuildContext sectionContext;




  final transactionManager = TransactionManager();

  AccountBloc() : super(AccountInitialState()) {

    // Go back event handler
    on<AccountGoBackEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }


        return Navigator.pop(sectionContext);



    });

    // Exit event handler
    on<AccountExitEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }


        AppNavigator.gotoHome(context: sectionContext);



    });


    on<AccountSetSenderAccountEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }

      metaData.senderAccount = event.senderAccountNum;
      emit(AccountSenderAccountEnterState());

    });

    on<AccountSetRecipientAccountEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }

      metaData.beneficiaryAccount = event.recipientAccountNum;
      emit(AccountRecipientAccountEnterState());

    });

  }

  void init({
    required BuildContext context,
    required HomeFlowItem data,
  }) {
    sectionContext = context;
    metaData = data;


  }


}