import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_api_bloc/model/todo_model.dart';

class TodoCardView extends StatelessWidget {
  final TodoModel todoModel;
  const TodoCardView({super.key, required this.todoModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      // padding: EdgeInsets.all(5),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(
                '2',
                style: GoogleFonts.roboto(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(todoModel.title),
            subtitle: Text(todoModel.description),
            trailing: PopupMenuButton(
              onSelected: (value) {
                if (value == 'edit') {
                } else if (value == 'delete') {
                  // deleteById(id);
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
          )
        ],
      ),
    );
  }
}
