part of "bloc.dart";

sealed class LoginState {}
//final class  LoginInitState extends LoginState {}
final class  LoginSelectUsersState extends LoginState {

  final bool isLoading;
  final String error;
  final List<StoredUser> users;

  LoginSelectUsersState({
    this.isLoading = true,
    this.error = "",
    this.users = const []
  });

}
final class  LoginPasswordState extends LoginState {}
final class  LoginSubmitPasswordState extends LoginState {

  final bool isLoading;
  final String error;

  LoginSubmitPasswordState({
    this.isLoading = true,
    this.error = "",
  });
}

final class  LoginGetTransactionsState extends LoginState {

  final bool isLoading;
  final String error;

  LoginGetTransactionsState({
    this.isLoading = true,
    this.error = "",
  });
}
