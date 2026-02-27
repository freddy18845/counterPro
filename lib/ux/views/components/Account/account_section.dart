import 'package:eswaini_destop_app/ux/blocs/shared/account/event.dart';
import 'package:eswaini_destop_app/ux/models/screens/home/flow_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/shared/account/bloc.dart';
import '../../fragements/account/own_account_section.dart';
import '../shared/card_widget.dart';

class AccountSection extends StatefulWidget {
  final HomeFlowItem data;
  final Function(HomeFlowItem? value) onTap;
  final Function(HomeFlowItem? data)  onExist;
  const AccountSection({super.key, required this.data, required this.onTap, required this.onExist});

  @override
  State<AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
  late AccountBloc accountBloc;

  @override
  void initState() {
    super.initState();
    accountBloc = context.read<AccountBloc>();
    accountBloc.init(context: context, data: widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: BlocConsumer<AccountBloc, AccountState>(
        // Listener for side effects (navigation, dialogs, toasts)
        listener: (context, state) {},

        // Builder for UI updates
        builder: (context, state) {
          final section = Container();
          if (state is AccountInitialState) {
            return OwnerAccountSection(
              key: UniqueKey(),
              onTap: (String accountNo) async {
                accountBloc.add(
                  AccountSetSenderAccountEvent(senderAccountNum: accountNo),
                );
                await Future.delayed(const Duration(milliseconds: 100));
                widget.onTap(accountBloc.metaData);
              },
              onCancel: () {
               widget.onExist(accountBloc.metaData);
              },
              data: accountBloc.metaData,
            );
          }

          return section;
        },
      ),
    );
  }
}
