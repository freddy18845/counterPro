import "dart:ui";

import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../blocs/screens/home/bloc.dart";
import "../../models/shared/transaction.dart";
import "../../utils/sessionManager.dart";
import "../../utils/shared/stock_monitor.dart";
import "../components/screens/home/right_card.dart";
import "../components/screens/home/transactions_list.dart";
import "../components/screens/home/upper_card.dart";
import "../components/shared/ui_template.dart";

class HomeScreen extends StatefulWidget {
  final TransactionData? transactionData;
  const HomeScreen({super.key, this.transactionData});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;

  @override
  void initState() {
    homeBloc = context.read<HomeBloc>();
    homeBloc.init(context: context);
    disableStockNotificationForCashier();
    super.initState();
  }
  Future<void>disableStockNotificationForCashier() async {
    if(SessionManager().isCashier){
      await StockMonitorService.setEnablePopupAlerts(
        false,
      );
    }
  }
  @override
  void dispose() {
    try {
      homeBloc.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      isHomeScreen: true,
      contentSection: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:  Column(
                children: [
                  Expanded(child: HomeUpperCard()),
                  SizedBox(height: ConstantUtil.verticalSpacing),
                  TransactionsSection(homeBloc: homeBloc),
                ],
              ),

          ),

          SizedBox(width: ConstantUtil.horizontalSpacing),

          // 3. Right Side: Receipt
          HomeRightSection(
transactionData:widget.transactionData,
          ),
        ],
      ),
    );
  }
}
