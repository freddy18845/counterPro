import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/app.dart";


part "event.dart";
part "state.dart";

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  bool busyState = false;
  String newPassword = "";
  String confirmPassword = "";
  late BuildContext sectionContext;
  StreamController<Map>? fieldController;
  StreamController<Map>? submitController;


  LoginBloc() : super(LoginSelectUsersState()) {
    on<LoginInitEvent>((event, emit) async {
     emit(LoginPasswordState());
    });



    on<LoginExitEvent>((event, emit) {
      if (busyState) {
        AppUtil.toastMessage(
          context:sectionContext,
          message: AppStrings.processingPleaseWait,
        );
        return;
      }
      Navigator.pop(sectionContext);
    });



    on<LoginSetUserEvent>((event, emit) async {
      // await TransactionManager().setCurrentUser(
      //   user: event.user,
      // );
      emit(LoginPasswordState());
    });

    on<LoginSetPasswordEvent>((event, emit) async {
      //   // 1. Save password to current user
     //TransactionManager().setCurrentPassword(psd: event.value);
      // 2. Update the OtpField visually
      fieldController?.add({"set_value": event.value});

      // 3. Enable the button only if password is 6 digits
      submitController?.add({"state": event.value.length >= 6});
    });



    on<LoginResetPasswordEvent>((event, emit) async {
      // bool? changed = await AppUtil.displayDialog(
      //   context: sectionContext,
      //   child: const ChangePasswordDialog(),
      // );
      // if (!sectionContext.mounted || (changed == null)) return;
      // if (changed) {
      //   AppUtil.toastMessage(
      //     message: AppStrings.passwordUpdatedSuccessfully,
      //   );
      // }
      // activeStep = LoginFlowStep.selectUser;
      // add(LoginGetUsersEvent());
    });

    on<LoginGetTransactionsEvent>((event, emit) async {
      if (busyState) {
        return; // 🚫 prevent duplicate calls
      }



      busyState = true;
      emit(
        LoginGetTransactionsState(
          isLoading: true,
        ),
      );

     //final currentUser = TransactionManager().terminalInfo.currentUser;
     //  TransactionQueryResponse result =
     //      await getTransactionHistory(currentUser!);
      if (!sectionContext.mounted) return;
      busyState = false;
      //if (result.responseCode != "00") {
        // emit(
        //   LoginGetTransactionsState(
        //     isLoading: false,
        //     error: result.responseText,
        //   ),
        // );
        return;
      //}
      //AppNavigator.gotoHome(context: sectionContext);
    });
  }

  void init({
    required BuildContext context,
  }) {
    sectionContext = context;
    // activation();
    busyState = false;
    submitController = StreamController.broadcast();
    fieldController = StreamController.broadcast();
  }

  void dispose() {
    submitController?.close();
    fieldController?.close();
  }

  // Future<TransactionQueryResponse> getTransactionHistory(
  //     StoredUser activeUser) async {
  //   final now = DateTime.now();
  //   final yesterday = now.subtract(const Duration(days: 1));
  //   final today = DateTime(now.year, now.month, now.day);
  //   final startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
  //   final endDate = DateTime(today.year, today.month, today.day, 23, 59, 59);
  //
  //   final dmc = activeUser.accessLevel == "3" ? '001' : '000';
  //
  //   final TransactionQueryResponse transactionQueryResponse =
  //       await repo.fetchTransactionsFromAPI(startDate, endDate, dmc);
  //
  //   final List<Map<String, dynamic>> transactions =
  //       transactionQueryResponse.queryResult;
  //   if (transactionQueryResponse.responseCode == "00") {
  //    // TransactionManager().addTransactionHistoryFromAPI(transactions);
  //   }
  //
  //   return transactionQueryResponse;
  // }
}
