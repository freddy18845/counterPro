import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/models/screens/home/flow_item.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:eswaini_destop_app/ux/res/app_theme.dart';
import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:eswaini_destop_app/ux/views/components/shared/processing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../platform/utils/utils.dart';
import '../../../blocs/shared/preview/bloc.dart';
import '../../../blocs/shared/processing/bloc.dart';
import '../../../models/shared/transaction.dart';
import '../../../nav/app_navigator.dart';
import 'Process_status_card.dart';
import 'api_response_summary_card.dart';

class ProcessingSection extends StatefulWidget {
  final HomeFlowItem metaData;
  final VoidCallback? onAction;
  final VoidCallback? onCancel;

  const ProcessingSection({
    super.key,
    required this.onAction,
    required this.onCancel,
    required this.metaData,
  });

  @override
  State<ProcessingSection> createState() => _ProcessingSectionState();
}

class _ProcessingSectionState extends State<ProcessingSection> {
  late ProcessingBloc processingBloc;
  late PreviewBloc previewBloc;
  TransactionData data = TransactionData();
  @override
  void initState() {
    super.initState();
    processingBloc = context.read<ProcessingBloc>();
    previewBloc = context.read<PreviewBloc>();
    previewBloc.init(context: context);
    processingBloc.init(context: context, data: widget.metaData);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProcessingBloc, ProcessingState>(
      // Listener for side effects (navigation, dialogs, toasts)
      listener: (context, state) {
        String dateTimeNow = getCurrentFormattedDateTime();
        data = TransactionData(
          transactionNo: 'TXN20240210145623789',
          messageType: widget.metaData.msgType,
          transactionType: widget.metaData.trsType,
          dateTime: dateTimeNow,
          countryCode: ConstantUtil.countryCode.toString(),
          receivingNetworkId: 'VISA001',
          receivingNetworkName: 'Visa International',
          merchantId: 'MER789456123',
          merchantName: ConstantUtil.defaultMerchantName,
          merchantLocation: ConstantUtil.defaultMerchantLocation,
          terminalId: 'TERM45678901',
          tellerId: 'TELL12345',
          tellerName: 'John Anderson',
          transactionId: 'e4f2a8b9-3c5d-4e7f-9a1b-2c3d4e5f6a7b',
          referenceInfo: 'REF2024021045623',
          tenderType:widget.metaData.paymentType.tenderType,
          pan:widget.metaData.paymentType==AppStrings.card?  '1234********4532':widget.metaData.pan,
          currency: widget.metaData.currency.code,
          transactionAmount: widget.metaData.amount.toStringAsFixed(
            int.parse(widget.metaData.currency.precision),
          ),
          cashBackAmount: '0.00',
          transactionFee: '0.00',
          account1:  widget.metaData.senderAccount,
          account2:  widget.metaData.beneficiaryAccount,
          responseCode: '00',
          authorizationCode: 'AUTH456789',
          authorizationReference: 'AUTHREF1',
          narration: ' ',
          approved: '00',
          reversed: '0',
        );

        if (state is ProcessingSuccessState) {
          // Show success message
          previewBloc.add(PreviewTransactionEvent(transactionData: data));
          AppUtil.toastMessage(
            context: context,
            message: 'Transaction successful!',
          );
        }

        if (state is ProcessingErrorState) {
          // Show error dialog
          previewBloc.add(PreviewTransactionEvent(transactionData: data));
        }
      },

      // Builder for UI updates
      builder: (context, state) {
        if (state is ProcessingLoadingState) {
          return ProcessingCard(
            isProcessing: true,
            isSuccessful: false,
            metaData: widget.metaData,
            onAction: widget.onAction,
            onCancel: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                ProcessingStatusCard(
                  data: widget.metaData.paymentType,
                  isProcessing: processingBloc.busyState,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: AppTheme.buildDivider(),
                ),
                Expanded(
                  child:
                      widget.metaData.paymentType.label == AppStrings.card ||
                          widget.metaData.paymentType.label == AppStrings.wallet
                      ? AppTheme.buildPinPadImage()
                      : AppTheme.buildProcessing(),
                ),
              ],
            ),
          );
        }

        if (state is ProcessingSuccessState) {
          return ProcessingCard(
            isProcessing: false,
            metaData: widget.metaData,
            onAction: () {
              AppNavigator.gotoHome(context: context);
            },
            onCancel: widget.onCancel,
            isSuccessful: true,
            child: Row(
              children: [
                ProcessingStatusCard(
                  data: widget.metaData.paymentType,
                  isProcessing: processingBloc.busyState,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: AppTheme.buildDivider(),
                ),
                Expanded(
                  child: ApiResponseSummaryCard(
                    metaData: widget.metaData,
                    transactionData: data,
                  ),
                ),
              ],
            ),
          );
        }

        // Default state
        return Container();
      },
    );
  }
}
