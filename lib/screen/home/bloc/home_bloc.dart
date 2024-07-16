import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_api_bloc/model/todo_model.dart';
import 'package:todo_api_bloc/service/todo_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<InitialEvent>(initialEvent);
    on<HomeAddButtonNavigationEvent>(homeAddButtonNavigationEvent);
    on<HomeAddButtonClickEvent>(homeAddButtonClickEvent);
  }

  FutureOr<void> initialEvent(
      InitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    await Future.delayed(Duration(seconds: 2));

    final value = await fetchTodo();
    final List<TodoModel> items = [];
    for (int i = 0; i < value.length; i++) {
      items.add(TodoModel(
          id: value[i]['_id'],
          title: value[i]['title'],
          description: value[i]['description']));
    }

    emit(HomeLoadedSuccessState(todoItem: items));
    print(items.length);
  }

  FutureOr<void> homeAddButtonNavigationEvent(
      HomeAddButtonNavigationEvent event, Emitter<HomeState> emit) {
    print("Addpage");
    emit(HomeNavigateToAddPageState());
  }

  FutureOr<void> homeAddButtonClickEvent(
      HomeAddButtonClickEvent event, Emitter<HomeState> emit) {
    print("iii");
  }
}
