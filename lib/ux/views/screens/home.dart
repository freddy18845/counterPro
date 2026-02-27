import "dart:ui";

import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../blocs/screens/home/bloc.dart";
import "../components/screens/home/transactions_list.dart";
import "../components/screens/home/upper_card.dart";
import "../components/shared/ui_template.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;

  @override
  void initState() {
    homeBloc = context.read<HomeBloc>();
    homeBloc.init(context: context);
    super.initState();
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
      contentSection:


          Column(children: [
           Expanded(child:  HomeUpperCard(),),
            SizedBox(height: ConstantUtil.verticalSpacing),
            TransactionsSection(homeBloc: homeBloc,),
          ],)



    );
  }
}
