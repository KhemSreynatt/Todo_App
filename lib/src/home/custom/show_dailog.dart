import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/todo_controller.dart';

onShowEditDialog(
    BuildContext context, TodoController todoController, int index) {
  final textController =
      TextEditingController(text: todoController.listTodo[index].title);
  final controller = Get.put(TodoController());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Obx(
        () => AlertDialog(
          title: const Text('Edit Item Todo'),
          content: TextFormField(
            controller: textController,
            autofocus: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: controller.isDuplicate.value == true
                  ? 'Item Duplicate'
                  : 'Item Todo',
              labelStyle: TextStyle(
                fontSize: 14,
                color: controller.isDuplicate.value == true
                    ? Colors.red
                    : Colors.blueGrey,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: controller.isDuplicate.value == true
                      ? Colors.red
                      : Colors.blueGrey,
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
                  todoController.editItem(context, index, newText);
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      );
    },
  );
}
