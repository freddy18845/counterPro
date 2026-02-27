import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../../platform/utils/sound.dart";
import "../../../Providers/transaction_provider.dart";
import "../../../models/screens/home/flow_item.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/app.dart";
import "../../screens/home/bloc.dart";
import "event.dart";

part "state.dart";

class ProcessingBloc extends Bloc<ProcessingEvent, ProcessingState> {
  //final String _tag = "ProcessingBloc";
  bool busyState = false;
  late HomeFlowItem metaData;
  late BuildContext sectionContext;
  late HomeBloc homeBloc;

  final transactionManager = TransactionManager();

  ProcessingBloc() : super(ProcessingInitialState()) {
    on<ProcessingGoBackEvent>((event, emit) {
      if (busyState) {
        AppUtil.toastMessage(message: AppStrings.processingPleaseWait, context: sectionContext);
        return;
      }

      // Removed StreamController usage
    });

    on<ProcessingExitEvent>((event, emit) {
      if (busyState) {
        AppUtil.toastMessage(context:sectionContext,message: AppStrings.processingPleaseWait);
        return;
      }

      // Removed StreamController usage
    });

    on<ProcessingSubmitTransactionEvent>((event, emit) async {
      busyState = true;
      emit(ProcessingLoadingState());

      print('=== Debug Mode - Skipping API Call ===');
      await Future.delayed(const Duration(seconds: 5));
      busyState = false;
      emit(ProcessingSuccessState());
      //await SoundUtil.playTone();
      // try {
      //   // Add your transaction implementation here
      //
      //   emit(ProcessingSuccessState());
      // } catch (e) {
      //   emit(ProcessingErrorState(e.toString()));
      // }
    });
  }

  void init({
    required BuildContext context,
    required HomeFlowItem data,
  }) {
    sectionContext = context;
    metaData = data;
    add(ProcessingSubmitTransactionEvent());
  }


}