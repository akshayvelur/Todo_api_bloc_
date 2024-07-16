part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}
class InitialEvent extends HomeEvent{}

class HomeAddButtonClickEvent extends HomeEvent {}

class HomeEditButtonClickEvent extends HomeEvent {}

class HomeAddButtonNavigationEvent extends HomeEvent {}

class HomeEditButtonNavigationEvent extends HomeEvent {}
