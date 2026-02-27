
import "../../../enums/shared/progress/action.dart";
import "../transaction.dart";


class ProgressInfo {
  
  TransactionData transaction=TransactionData();
  ProgressAction action = ProgressAction.none;
  String logs = "";
  bool resCode36Retried = false;
  bool isCardIC = false;
  
}
