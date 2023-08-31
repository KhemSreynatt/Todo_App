import 'package:flutter/material.dart';

import '../controller/todo_controller.dart';

onShowEditDialog(
    BuildContext context, TodoController todoController, int index) {
  final textController =
      TextEditingController(text: todoController.listTodo[index]);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Item Todo'),
        content: TextFormField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Item Todo',
            labelStyle: const TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                // width: 1.8,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newText = textController.text.trim();
              if (newText.isNotEmpty) {
                todoController.updateTodoAt(index, newText);
              }
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );
}
