// import "dart:async";
// import "package:flutter/material.dart";
// import "package:flutter_bloc/flutter_bloc.dart";
// import "../../../Providers/transaction_provider.dart";
// import "../../../enums/shared/progress/action.dart";
// import "../../../enums/sub_screens/payment/flow_step.dart";
// import "../../../enums/sub_screens/payment/payment_type.dart";
// import "../../../models/screens/home/flow_item.dart";
// import "../../../models/shared/transaction.dart";
// import "../../../models/terminal_sign_on_response.dart";
// import "../../../nav/app_navigator.dart";
// import "../../../res/app_strings.dart";
// import "../../../utils/shared/app.dart";
// import "../../../views/components/dialogs/currency.dart";
// import "../../screens/home/bloc.dart";
// import "event.dart";
//
// part "state.dart";
//
// class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
//   //final String _tag = "PaymentBloc";
//   bool busyState = false;
//   late HomeFlowItem metaData;
//   late BuildContext sectionContext;
//   late HomeBloc homeBloc;
//   SaleFlowStep activeStep = SaleFlowStep.enterAmount;
//   StreamController<Map>? fieldController;
//   StreamController<Map>? submitController;
//   StreamController<Map>? subSectionController;
//
//   final transactionManager = TransactionManager();
//   PaymentBloc() : super(PaymentEnterAmountState()) {
//     on<PaymentGoBackEvent>((event, emit) {
//       if (busyState) {
//         return AppUtil.toastMessage(message: AppStrings.processingPleaseWait);
//       }
//       if (activeStep == SaleFlowStep.enterAmount) {
//         return Navigator.pop(sectionContext);
//       }
//
//       final fieldData = {"set_amount": metaData.amount};
//       fieldController?.add(fieldData);
//       submitController?.add({"update_state": metaData.amount > 0});
//       subSectionController?.add({"go_back": true});
//     });
//
//     on<PaymentExitEvent>((event, emit) {
//       if (busyState) {
//         return AppUtil.toastMessage(message: AppStrings.processingPleaseWait);
//       }
//       if (activeStep == SaleFlowStep.enterAmount) {
//         AppNavigator.gotoHome(context: sectionContext);
//       }
//
//       subSectionController?.add({"exit": true});
//     });
//
//     on<PaymentPromptCurrencyEvent>((event, emit) async {
//       List<Currency> currencies = (await transactionManager.getCurrencies());
//       if (currencies.isEmpty) return; // Safety check
//
//       if (currencies.length <= 1) {
//         metaData.currency = currencies[0];
//       } else {
//         // Set default currency if null
//         metaData.currency ??= currencies.first;
//
//         Currency? res = await AppUtil.displayDialog(
//           dismissible: false,
//           context: sectionContext,
//           child: CurrencyDialog(
//             selectedCurrency: metaData.currency!,  // Now safe to use !
//           ),
//         );
//         if (!sectionContext.mounted) return;
//         if ((metaData.currency == null) && (res == null)) {
//           Navigator.pop(sectionContext);
//           return;
//         }
//         metaData.currency = res;
//         metaData.forceSelectCurrency = true;
//         transactionManager.setActiveCurrency(res!);
//       }
//       emit(PaymentEnterAmountState());
//     });
//
//
//     on<PaymentSetCurrencyEvent>((event, emit) async {
//       List<Currency> currencies = (await transactionManager.getCurrencies());
//       if (currencies.length <= 1) {
//         metaData.currency = currencies[0];
//       } else {
//         metaData.currency = event.data;
//         metaData.forceSelectCurrency = true;
//       }
//       // emit(PaymentEnterAmountState());
//     });
//
//
//
//     on<PaymentSetAmountEvent>((event, emit) {
//       metaData.amount = event.amount;
//
//       final fieldData = {"set_amount": event.amount};
//       fieldController?.add(fieldData);
//       submitController?.add({"update_state": event.amount > 0});
//     });
//
//     on<PaymentSetPaymentTypeEvent>((event, emit) async {
//      // metaData.paymentType = event.type;
//       final currency = await transactionManager.getCurrency();
//       if (currency != null) {
//         metaData.currency = currency;
//       }
//
//       if (metaData.paymentType == SalePaymentType.card) {
//         metaData.resCode36Retried = false;
//       }
//       emit(PaymentPaymentOptionState());
//     });
//
//     // on<PaymentCardFlowResEvent>((event, emit) {
//     //   if (event.data == null) return emit(PaymentEnterAmountState());
//     //   if ((event.data?.error ?? "").isNotEmpty) {
//     //     AppUtil.toastMessage(message: event.data?.error ?? "");
//     //     return emit(PaymentEnterAmountState());
//     //   }
//     //   metaData.cardInfo = event.data;
//     //   emit(PaymentSubmitTransactionState());
//     // });
//
//
//
//     on<PaymentProgressResEvent>((event, emit) {
//       if (event.data == null) return emit(PaymentEnterAmountState());
//       if (event.data?.action == ProgressAction.retryPinOnWrongPin) {
//         AppUtil.toastMessage(
//           message: AppStrings.incorrectPin,
//         );
//         emit(PaymentPaymentOptionState(
//           forcePinOnCardFlow: true,
//         ));
//         return;
//       }
//       if (event.data?.action == ProgressAction.retryPinOnExceededLimit) {
//         metaData.resCode36Retried = event.data?.resCode36Retried ?? false;
//         if (metaData.resCode36Retried) {
//           AppUtil.toastMessage(
//             message: AppStrings.exceededUsageLimit,
//           );
//           emit(PaymentPaymentOptionState(
//             forcePinOnCardFlow: true,
//           ));
//         }
//         return;
//       }
//
//       if (event.data?.transaction != null) {
//         return emit(
//           PaymentReceiptState(
//             transaction: event.data!.transaction,
//           ),
//         );
//       }
//       emit(PaymentEnterAmountState());
//     });
//   }
//
//   void init({
//     required BuildContext context,
//     required HomeFlowItem data,
//     required StreamController<Map> refreshController,
//   }) {
//     sectionContext = context;
//     metaData = HomeFlowData(
//       flowItem: data,
//       refreshController: refreshController,
//     );
//     submitController = StreamController.broadcast();
//     fieldController = StreamController.broadcast();
//     subSectionController = StreamController.broadcast();
//   }
//
//   void dispose() {
//     submitController?.close();
//     fieldController?.close();
//     subSectionController?.close();
//   }
// }
