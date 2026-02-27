part of "bloc.dart";

sealed class SplashState {}
final class SplashLoadingState extends SplashState {}
final class SplashErrorState extends SplashState {
  final String message;
  SplashErrorState({required this.message});
}
