import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_api_bloc/model/todo_model.dart';

Future<List<dynamic>> fetchTodo() async {
  // setState(() {
  //   _isLoading = false;
  // });
  print("Datafetching");
  final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    // final result = json['items'];
    return json['items'];
    // print(response.body);
    // print(response.statusCode);
  } else {
    return [];
  }
  // setState(() {
  //   _isLoading = false;
  // });
}
