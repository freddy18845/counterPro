
import '../../screens/home/flow_item.dart';
import '../../terminal_sign_on_response.dart';


class WalletProcessInput {

  double amount;
  double cashbackAmount;
  Currency currency;
  HomeFlowItem flowItem;

  WalletProcessInput({
    required this.amount,
    this.cashbackAmount = 0.0,
    required this.currency,
    required this.flowItem
  });
  
}
