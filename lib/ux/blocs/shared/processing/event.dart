
import '../../../models/shared/progress/info.dart';
import '../../../models/terminal_sign_on_response.dart';

sealed class ProcessingEvent {}
final class  ProcessingExitEvent extends ProcessingEvent {}
final class  ProcessingGoBackEvent extends ProcessingEvent {}
final class  ProcessingSubmitTransactionEvent extends ProcessingEvent {}


