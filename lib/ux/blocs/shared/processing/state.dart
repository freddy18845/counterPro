part of 'bloc.dart';

abstract class ProcessingState {}

class ProcessingInitialState extends ProcessingState {}

class ProcessingLoadingState extends ProcessingState {}

class ProcessingSuccessState extends ProcessingState {}

class ProcessingErrorState extends ProcessingState {
  final String message;
  ProcessingErrorState(this.message);
}