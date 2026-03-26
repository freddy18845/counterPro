part of "bloc.dart";

sealed class LoginEvent {}
final class  LoginInitEvent extends LoginEvent {}
final class  LoginGetUsersEvent extends LoginEvent {}
final class  LoginSetUserEvent extends LoginEvent {



  // LoginSetUserEvent({required this.user,});
}
final class  LoginSetPasswordEvent extends LoginEvent {

  final String value;

  LoginSetPasswordEvent({required this.value,});
}
final class  LoginSubmitPasswordEvent extends LoginEvent {}
final class  LoginResetPasswordEvent extends LoginEvent {}
// final class  LoginSetNewPasswordEvent extends LoginEvent {
//
//   final String value;
//
//   LoginSetNewPasswordEvent({required this.value,});
//}
// final class  LoginSubmitNewPasswordEvent extends LoginEvent {}
final class  LoginSetConfirmPasswordEvent extends LoginEvent {

  final String value;

  LoginSetConfirmPasswordEvent({required this.value,});
}
final class  LoginSubmitConfirmPasswordEvent extends LoginEvent {}
final class  LoginGetTransactionsEvent extends LoginEvent {}
final class  LoginGoBackEvent extends LoginEvent {}
final class  LoginExitEvent extends LoginEvent {}
