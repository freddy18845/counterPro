


import '../../terminal_sign_on_response.dart';


class QrProcessInput {

  double amount;
  double cashbackAmount;
  Currency currency;

  QrProcessInput({
    required this.amount,
    this.cashbackAmount = 0.0,
    required this.currency,
  });
  
}
