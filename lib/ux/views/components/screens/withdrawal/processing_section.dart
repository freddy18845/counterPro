import 'package:flutter/cupertino.dart';
import '../../../../blocs/screens/withdrawal/bloc.dart';
import '../../shared/Processing_section.dart';

class WithdrawalProcessingSection extends StatelessWidget {
  final WithdrawalBloc bloc;

  const WithdrawalProcessingSection({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return ProcessingSection(
        metaData:bloc.metaData,
      onAction:  () {

      },
      onCancel: () {
        // Trigger cancel event
        //   bloc.add(WithdrawalCancelEvent());
      },
    );
  }
}