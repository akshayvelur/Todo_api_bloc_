import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController decriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: titleController,
              decoration: InputDecoration(hintText: "Title"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: decriptionController,
              decoration: InputDecoration(
                hintText: "Decription",
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
                onPressed: () {
                  submi();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Submit",
                  style: GoogleFonts.roboto(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }

  Future<void> submi() async {
    //Get data from form
    final title = titleController.text;
    final decription = decriptionController.text;
    final body = {
      "title": title,
      "description": decription,
      "is_completed": false
    };

    //submit data to the sever
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //show success or fail massage

    if (response.statusCode == 201) {
      print("creation success");
      titleController.text = '';
      decriptionController.text = '';
      ShowSuccessMessage('Creation Success');
   
    } else {
      print("creation faild");
      ShowErrorMessage('creation failed');
      print(response.statusCode);
    }
  }

  void ShowSuccessMessage(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void ShowErrorMessage(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: TextStyle(color: Colors.red),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
