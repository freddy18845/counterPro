import "dart:async";
import "package:eswaini_destop_app/ux/models/screens/home/flow_item.dart";
import "package:eswaini_destop_app/ux/views/components/P2P/p2p_account_section.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../blocs/screens/withdrawal/bloc.dart";
import "../../blocs/screens/withdrawal/event.dart";
import "../../enums/screens/payment/flow_step.dart";
import "../components/Account/account_section.dart";
import "../components/screens/withdrawal/amount_section.dart";
import "../components/screens/withdrawal/processing_section.dart";
import "../components/shared/ui_template.dart";
import "../components/wallet/wallet_Section.dart";

class WithdrawalScreen extends StatefulWidget {
  final HomeFlowItem selectedTransaction;
  final StreamController<Map> refreshController;
  const WithdrawalScreen({
    super.key,
    required this.selectedTransaction,
    required this.refreshController,
  });
  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  late WithdrawalBloc withdrawalBloc;

  @override
  void initState() {
    withdrawalBloc = context.read<WithdrawalBloc>();
    withdrawalBloc.init(
      context: context,
      data: widget.selectedTransaction,
      refreshController: widget.refreshController,
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      withdrawalBloc.add(WithdrawalPromptCurrencyEvent());
    });
  }

  @override
  void dispose() {
    try {
      withdrawalBloc.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      contentSection: BlocBuilder<WithdrawalBloc, WithdrawalState>(
        builder: (context, WithdrawalState state) {
          Widget section = Container();
          if (state is WithdrawalEnterAmountState) {
            withdrawalBloc.activeStep = GeneralTransactionFlowStep.enterAmount;
            section = WithdrawalAmountSection(
              key: UniqueKey(),
              bloc: withdrawalBloc,
              // metaData: withdrawalBloc.metaData,
            );
          }
          if (state is WithdrawalPaymentMethodSelectedState) {
            withdrawalBloc.activeStep =
                GeneralTransactionFlowStep.submitTransaction;
            return WithdrawalProcessingSection(
              key: UniqueKey(),
              bloc: withdrawalBloc,
            );
          }

          if (state is WithdrawalSelectedWalletState) {
            withdrawalBloc.activeStep = GeneralTransactionFlowStep.payment;

            return WalletSection(
              key: UniqueKey(),
              data: withdrawalBloc.metaData,
              onTap: (HomeFlowItem? value) {
                withdrawalBloc.add(WithdrawalProgressResEvent(data: value!));
              },
              onExist: (HomeFlowItem? data) {
                withdrawalBloc.add(WithdrawalExitEvent());
              },
              // metaData: withdrawalBloc.metaData,
            );
          }
          if (state is WithdrawalPaymentMethodAccountState) {
            withdrawalBloc.activeStep = GeneralTransactionFlowStep.payment;

            return AccountSection(
              key: UniqueKey(),
              data: withdrawalBloc.metaData,
              onTap: (HomeFlowItem? value) {
                withdrawalBloc.add(WithdrawalProgressResEvent(data: value!));
              },
              onExist: (HomeFlowItem? data) {
                withdrawalBloc.add(WithdrawalExitEvent());
              },
            );
          }
          if (state is WithdrawalPaymentMethodP2PState) {
            withdrawalBloc.activeStep = GeneralTransactionFlowStep.payment;

            return P2PAccountSection(
              key: UniqueKey(),
              data: withdrawalBloc.metaData,
              onTap: (HomeFlowItem? value) {
                withdrawalBloc.add(WithdrawalProgressResEvent(data: value!));
              },
              onExist: (HomeFlowItem? data) {
                withdrawalBloc.add(WithdrawalExitEvent());
              },
              // metaData: withdrawalBloc.metaData,
            );
          }

          return section;
        },
      ),
    );
  }
}
