import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_api_bloc/screen/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List item = [];
  bool _isLoading = true;
  @override
  void initState() {
    fetchTodo();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Visibility(
        visible: _isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: item.length,
            itemBuilder: (context, index) {
              final myitem = item[index] as Map;
              final id = myitem['_id'] as String;
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.roboto(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(myitem['title']),
                subtitle: Text(myitem['description']),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                    } else if (value == 'delete') {
                      deleteById(id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text('Edit'),
                        value: 'edit',
                      ),
                      PopupMenuItem(
                        child: Text('Delete'),
                        value: 'delete',
                      )
                    ];
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          NavigateToAddPage();
        },
        label: Text("Add Todo"),
      ),
    );
  }

  void NavigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchTodo() async {
    // setState(() {
    //   _isLoading = false;
    // });

    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        item = result;
      });
      print(response.body);
      print(response.statusCode);
    } else {}
    setState(() {
      _isLoading = false;
    });
  }

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
