import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_api_bloc/model/todo_model.dart';
import 'package:todo_api_bloc/screen/add_page/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api_bloc/screen/home/bloc/home_bloc.dart';
import 'package:todo_api_bloc/screen/home/ui/todo_card_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc homeBloc = HomeBloc();
  List item = [];
  bool _isLoading = true;
  @override
  void initState() {
    // fetchTodo();
    homeBloc.add(InitialEvent());
    // TODO: implement initState
    // todoBloc.add();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionSatate,
      buildWhen: (previous, current) => current is! HomeActionSatate,
      listener: (context, state) {
        if (state is HomeNavigateToAddPageState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTodoPage()));
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case HomeLoadedSuccessState:
            final successState = state as HomeLoadedSuccessState;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Text(
                  'Todo List',
                  style: GoogleFonts.roboto(
                      color: Color.fromARGB(209, 255, 255, 255),
                      fontWeight: FontWeight.bold),
                ),
              ),
              body: ListView.builder(
                itemCount: successState.todoItem.length,
                itemBuilder: (context, index) {
                  return TodoCardView(todoModel: successState.todoItem[index]);
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  homeBloc.add(HomeAddButtonNavigationEvent());
                },
                label: Text("Add Todo"),
              ),
            );
          case HomeErroState:
            return Scaffold(
              body: Center(
                child: Text("Error"),
              ),
            );
          default:
            return SizedBox();
        }
      },
    );
  }

//Navigate to add page
  // Future<void> NavigateToAddPage() async {
  //   final route = MaterialPageRoute(
  //     builder: (context) => AddTodoPage(),
  //   );
  //   await Navigator.push(context, route);
  //   fetchTodo();
  //   setState(() {
  //     _isLoading = true;
  //   });
  // }

// Navigate to editpage
  // Future<void> NavigateToEditPage(Map item) async {
  //   final route = MaterialPageRoute(
  //     builder: (context) => AddTodoPage(todo: item),
  //   );
  //   await Navigator.push(context, route);
  //   fetchTodo();
  //   setState(() {
  //     _isLoading = true;
  //   });
  // }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      deleteMessage();
      final filter = item
          .where(
            (element) => element['_id'] != id,
          )
          .toList();
      setState(() {
        item = filter;
      });
      deleteMessage();
    }
  }

  void deleteMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      "Deleted ....",
      style: GoogleFonts.roboto(color: Colors.red),
    )));
  }
}
