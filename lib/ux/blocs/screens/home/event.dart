part of "bloc.dart";

sealed class HomeEvent {}
final class  HomeSwitchTab extends HomeEvent {

  final int activeTab;
  HomeSwitchTab({required this.activeTab,});

}
final class  HomeBaseSecStartFlow extends HomeEvent {

  final HomeFlowItem item;
  final  double? amount;

  HomeBaseSecStartFlow({this.amount,required this.item,});

}
final class  HomeLogoutEvent extends HomeEvent {}

