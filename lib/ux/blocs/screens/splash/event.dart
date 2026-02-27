part of "bloc.dart";

sealed class SplashEvent {}
final class SplashInitEvent extends SplashEvent {
  final BuildContext context;
  SplashInitEvent({required this.context});
}
