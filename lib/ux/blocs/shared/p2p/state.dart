part of 'bloc.dart';

abstract class P2PState {
  const P2PState();
}

// Initial state
class P2PInitialState extends P2PState {
  const P2PInitialState();
}

// Loading state
class P2PLoadingState extends P2PState {
  const P2PLoadingState();
}

// Balance loaded state
class P2PSenderP2PEnterState extends P2PState {}

class P2PRecipientP2PEnterState extends P2PState {}
