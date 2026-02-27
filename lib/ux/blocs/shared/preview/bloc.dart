import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../models/shared/transaction.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/app.dart";

part "event.dart";
part "state.dart";

class PreviewBloc extends Bloc<PreviewEvent, PreviewState> {
  bool busyState = false;
  late BuildContext sectionContext;
   TransactionData transaction =TransactionData() ;

  PreviewBloc() : super(PreviewInitState()) {
    on<PreviewPrintEvent>((event, emit) {
      if (busyState) {
        return AppUtil.toastMessage(context:sectionContext,message: AppStrings.processingPleaseWait);
      }
      Navigator.pop(sectionContext);
    });

    on<PreviewTransactionEvent>((event, emit) {
      transaction = event.transactionData;
      print(transaction.toJson());
      emit( PreviewInitState());

    });
  }

  void init({required BuildContext context}) {
    sectionContext = context;
    busyState = false;
  }

  void dispose() {}
}
