part of "bloc.dart";

sealed class HomeState {}
final class  HomeInitState extends HomeState {

  final int activeTab;

  HomeInitState({this.activeTab = 0,});

}
