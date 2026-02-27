// import "dart:async";
// import "package:flutter/material.dart";
// import "package:flutter_bloc/flutter_bloc.dart";
// import "../../../../platform/utils/utils.dart";
// import "../../../Providers/transaction_provider.dart";
// import "../../../enums/sub_screens/transactions/sort_filter.dart";
// import "../../../models/shared/transaction.dart";
// import "../../../models/shared/transaction_query_response.dart";
// import "../../../models/sub_screens/transactions/date_range.dart";
// import "../../../nav/app_navigator.dart";
// import "../../../res/app_strings.dart";
// import "../../../utils/api_service.dart";
// import "../../../utils/shared/app.dart";
// import "../../../views/components/dialogs/filter.dart";
// import "../../../views/components/dialogs/sort.dart";
// import "../../../views/screens/sub_screens/transactions.dart";
// import "../../screens/home/bloc.dart";
//
// part "event.dart";
// part "state.dart";
//
// class TransactionsBloc extends Bloc<TransactionsEvent,TransactionsState> {
//
//   bool busyState = false;
//   late HomeBloc homeBloc;
//   late BuildContext sectionContext;
//   late TabController tabController;
//   late TransactionsDateRange dateRange;
//   List<TransactionData> transactions = [];
//   List<String> tabs = [ AppStrings.details, AppStrings.summary ];
//   StreamController<Map>? sortSectionController;
//   StreamController<Map>? bottomActionsController;
//
//
//   TransactionsBloc() : super(TransactionsInitState()) {
//
//     on<TransactionsGoBackEvent>((event,emit) {
//       if (busyState) {
//         return AppUtil.toastMessage(message: AppStrings.processingPleaseWait,);
//       }
//       homeBloc.bottomNavController.add({"switch": 0});
//       AppNavigator.gotoHome(
//         context: sectionContext,
//       );
//     });
//
//     on<TransactionsGoHomeEvent>((event,emit) {
//       homeBloc.bottomNavController.add({"switch": 0});
//       AppNavigator.gotoHome(
//         context: sectionContext,
//       );
//     });
//
//     on<TransactionsLoadEvent>((event,emit) async {
//       if (busyState) {
//         return ;
//       }
//       busyState = true;
//       emit(TransactionsInitState(isLoading: true,));
//       transactions = [];
//
//       bottomActionsController?.add({"visible":false});
//       sortSectionController?.add({"set_count":0});
//       final dmc = TransactionManager().terminalInfo.currentUser?.accessLevel == "3" ? '001' : '000';
//         TransactionQueryResponse response = await apiService
//           .fetchTransactionsFromAPI( apiToDartDate(dateRange.startDate), apiToDartDate(dateRange.endDate), dmc);
//
//       if (!sectionContext.mounted) return;
//       busyState = false;
//       if (response.responseCode !='00') {
//         return emit(TransactionsInitState(
//           isLoading: false,
//           error: response.responseText,
//         ),);
//       }
//       transactions = response.queryResult
//           .map<TransactionData>(
//             (e) => TransactionData.fromJson(e),
//       )
//           .toList();
//
//       bottomActionsController?.add({"visible":transactions.isNotEmpty});
//       sortSectionController?.add({"set_count":transactions.length});
//       emit(TransactionsInitState(
//         isLoading: false,
//         transactions:transactions,
//       ),);
//     });
//
//     on<TransactionsSetDateRangeEvent>((event,emit) {
//       dateRange = event.range;
//       add(TransactionsLoadEvent());
//     });
//
//     on<TransactionsOpenFilterEvent>((event,emit) async {
//       if (transactions.isEmpty) {
//         return AppUtil.toastMessage(message: AppStrings.noTransaction,);
//       }
//       if (event.type == TransactionsSortFilter.sort) {
//         SortDialogAction? res = await AppUtil.displayDialog(
//           context: sectionContext, child: const SortDialog(),
//         );
//         if (!sectionContext.mounted || (res == null)) return;
//         if (res == SortDialogAction.asc) {
//           emit(TransactionsInitState(isLoading: false, transactions: transactions,),);
//         } else {
//           emit(TransactionsInitState(
//             isLoading: false,
//             transactions: transactions.reversed.toList(),
//           ),);
//         }
//       } else {
//         FilterDialogResult? res = await AppUtil.displayDialog(
//           context: sectionContext, child: const FilterDialog(),
//         );
//         if (!sectionContext.mounted || (res == null)) return;
//         busyState = true;
//         bottomActionsController?.add({"visible":false});
//         emit(TransactionsInitState(isLoading: true,));
//         await Future.delayed(const Duration(seconds: 1));
//         if (!sectionContext.mounted) return;
//         List<TransactionData> trans1 = [];
//         if (res.statuses.isNotEmpty) {
//           for (int a = 0; a < res.statuses.length; a++) {
//             if (res.statuses[a] == AppStrings.approved) {
//               for (int b = 0; b < transactions.length; b++) {
//                 if (transactions[b].approved == "1") { trans1.add(transactions[b]); }
//               }
//             }
//             if (res.statuses[a] == AppStrings.declined) {
//               for (int b = 0; b < transactions.length; b++) {
//                if (transactions[b].approved == "0") { trans1.add(transactions[b]); }
//               }
//             }
//             if (res.statuses[a] == AppStrings.void_) {
//               for (int b = 0; b < transactions.length; b++) {
//                 if (transactions[b].reversed == "1") { trans1.add(transactions[b]); }
//               }
//             }
//           }
//         } else {
//           trans1 = transactions;
//         }
//         List<TransactionData> trans2 = [];
//         if (res.tenderTypes.isNotEmpty) {
//           for (int a = 0; a < res.tenderTypes.length; a++) {
//             if (res.tenderTypes[a] == AppStrings.card) {
//               for (int b = 0; b < trans1.length; b++) {
//                 if (trans1[b].tenderType == '01') {
//                   trans2.add(trans1[b]);
//                 }
//               }
//             }
//             if (res.tenderTypes[a] == AppStrings.wallet) {
//               for (int b = 0; b < trans1.length; b++) {
//                 if (trans1[b].tenderType == '02') {
//                   trans2.add(trans1[b]);
//                 }
//               }
//             }
//             if (res.tenderTypes[a] == AppStrings.qrCode) {
//               for (int b = 0; b < trans1.length; b++) {
//                 if (trans1[b].tenderType == '03') {
//                   trans2.add(trans1[b]);
//                 }
//               }
//             }
//           }
//         } else {
//           trans2 = trans1;
//         }
//         busyState = false;
//         bottomActionsController?.add({"visible":trans2.isNotEmpty});
//         emit(TransactionsInitState(isLoading: false, transactions: trans2,
//         ),);
//       }
//     });
//
//     // on<TransactionsPreviewEvent>((event,emit) {
//     //   AppNavigator.gotoPreview(context: sectionContext, transaction:event.transaction,
//     //  );
//     //});
//
//     on<TransactionsPrintEvent>((event,emit) async {
//       // SvnUtilityPrinterPrintResult result = (
//       //     await SvnUtility.i.printerManager.startPrinting(
//       //       context: sectionContext,
//       //       inputData: SvnUtilityPrinterPrintInput(
//       //         inputType: tabController.index == 0
//       //             ? SvnUtilityPrinterPrintInputType.history : SvnUtilityPrinterPrintInputType.summary,
//       //         transactions:[],
//       //         //transactions,
//       //         startDate: dateRange.startDate.apiToDartDate(),
//       //         endDate: dateRange.endDate.apiToDartDate(),
//       //       ),
//       //     )
//       // );
//       // if (!sectionContext.mounted) return;
//       // if (!result.isSuccess) {
//       //   return AppUtil.toastMessage(message: result.message,);
//       // }
//     });
//
//   }
//
//   void init({
//     required BuildContext context,
//     required HomeBloc homeB,
//     required TransactionsDateRange range,
//     required TransactionsScreenState sectionState,
//   }) {
//     sectionContext = context;
//     homeBloc = homeB;
//     dateRange = range;
//     transactions = [];
//     busyState = false;
//     tabController = TabController(length: 2, vsync: sectionState);
//     sortSectionController = StreamController.broadcast();
//     bottomActionsController = StreamController.broadcast();
//   }
//
//   void dispose() {
//     tabController.dispose();
//     sortSectionController?.close();
//     bottomActionsController?.close();
//   }
//
// }
