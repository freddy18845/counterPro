import 'package:eswaini_destop_app/ux/models/screens/home/flow_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/shared/p2p/bloc.dart';
import '../../../blocs/shared/p2p/event.dart';
import '../../../enums/shared/p2p/flow.dart';
import '../../fragements/p2p/receiver_account_section.dart';
import '../../fragements/p2p/sender_account_section.dart';
import '../shared/card_widget.dart';

class P2PAccountSection extends StatefulWidget {
  final HomeFlowItem data;
  final Function(HomeFlowItem? value) onTap;
  final Function(HomeFlowItem? data)  onExist;
  const P2PAccountSection({super.key, required this.data, required this.onTap, required this.onExist});

  @override
  State<P2PAccountSection> createState() => _P2PAccountSectionState();
}

class _P2PAccountSectionState extends State<P2PAccountSection> {
  late P2PBloc p2pBloc;

  @override
  void initState() {
    super.initState();
    p2pBloc = context.read<P2PBloc>();
    p2pBloc.init(context: context, data: widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: BlocConsumer<P2PBloc, P2PState>(
        // Listener for side effects (navigation, dialogs, toasts)
        listener: (context, state) {},

        // Builder for UI updates
        builder: (context, state) {
          final section = Container();
          if (state is P2PInitialState) {
            p2pBloc.activeStep = P2PFlow.senderAccountNum;
            return SenderAccountSection(
              key: UniqueKey(),
              onTap: (String accountNo) async {
                p2pBloc.add(
                  P2PSetSenderAccountEvent(senderAccountNum: accountNo),
                );
                await Future.delayed(const Duration(milliseconds: 100));
              },
              onCancel: () {
               widget.onExist(p2pBloc.metaData);
              },
              data: p2pBloc.metaData,
            );
          }
          if (state is P2PSenderP2PEnterState) {
            p2pBloc.activeStep = P2PFlow.sendTransaction;
            return RecipientAccountSection(
              key: UniqueKey(),
              onTap: (String accountNo) async {
                p2pBloc.add(
                  P2PSetRecipientAccountEvent(recipientAccountNum: accountNo),
                );
                await Future.delayed(const Duration(milliseconds: 100));
                widget.onTap(p2pBloc.metaData);
              },
              onCancel: () {
                p2pBloc.add(P2PGoBackEvent());
              },
              data: p2pBloc.metaData,
            );
          }

          return section;
        },
      ),
    );
  }
}
