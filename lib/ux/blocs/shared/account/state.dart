part of 'bloc.dart';

abstract class AccountState {
  const AccountState();
}

// Initial state
class AccountInitialState extends AccountState {
  const AccountInitialState();
}

// Loading state
class AccountLoadingState extends AccountState {
  const AccountLoadingState();
}

// Balance loaded state
class AccountSenderAccountEnterState extends AccountState {}

class AccountRecipientAccountEnterState extends AccountState {}
