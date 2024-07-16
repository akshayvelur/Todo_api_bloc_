part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class HomeActionSatate extends HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedSuccessState extends HomeState {
  final List<TodoModel> todoItem;

  HomeLoadedSuccessState({required this.todoItem});
}

class HomeErroState extends HomeState {}

class HomeNavigateToAddPageState extends HomeActionSatate {}
