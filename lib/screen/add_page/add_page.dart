import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController decriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    final todos = widget.todo;
    if (todos != null) {
      isEdit = true;
      final title = todos['title'];
      final description = todos['description'];
      titleController.text = title;
      decriptionController.text = description;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edi Todo" : "Add Todo"),
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
                  isEdit ? UpdateData() : submi();
                  // Navigator.of(context).pop();
                },
                child: Text(
                  isEdit ? "Update" : "Submit",
                  style: GoogleFonts.roboto(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }

//Update data
  Future<void> UpdateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("You can not call update with out data");
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final decription = decriptionController.text;
    final body = {
      "title": title,
      "description": decription,
      "is_completed": false
    };
    //submit update Data
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      print("creation success");

      ShowSuccessMessage('Updation Success');
    } else {
      ShowErrorMessage('Updation failed');
      print(response.statusCode);
    }
  }

// Data submision
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
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
