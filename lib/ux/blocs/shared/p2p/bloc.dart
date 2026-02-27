
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../Providers/transaction_provider.dart";
import "../../../enums/screens/payment/flow_step.dart";
import "../../../enums/shared/p2p/flow.dart";
import "../../../models/screens/home/flow_item.dart";
import "../../../nav/app_navigator.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/app.dart";
import "event.dart";
part "state.dart";

class P2PBloc extends Bloc<P2PEvent, P2PState> {
  bool busyState = false;
  late HomeFlowItem metaData;
  late BuildContext sectionContext;
  P2PFlow activeStep = P2PFlow.senderAccountNum;



  final transactionManager = TransactionManager();

  P2PBloc() : super(P2PInitialState()) {

    // Go back event handler
    on<P2PGoBackEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }

      emit(P2PInitialState());


    });

    // Exit event handler
    on<P2PExitEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }




    });


    on<P2PSetSenderAccountEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }

      metaData.senderAccount = event.senderAccountNum;
       activeStep = P2PFlow.recipientAccountNum;
      emit(P2PSenderP2PEnterState());

    });

    on<P2PSetRecipientAccountEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(
          context: sectionContext,
          message: AppStrings.processingPleaseWait,
        );
      }

      metaData.beneficiaryAccount = event.recipientAccountNum;
      activeStep = P2PFlow.sendTransaction;
      emit(P2PRecipientP2PEnterState());

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