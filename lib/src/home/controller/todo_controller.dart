import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vtech_todo/src/home/model/todo_model.dart';

class TodoController extends GetxController {
  final isSearch = false.obs;
  final isCompele = false.obs;
  final isDuplicate = false.obs;

  final listTodo = <TodoModel>[
    TodoModel(title: 'Flutter Dev'),
    TodoModel(
      title: 'Web Dev',
    )
  ].obs;
  final listFilter = <TodoModel>[].obs;

  addItem(String title) {
    final item = TodoModel(title: title);
    if (!listTodo.any((element) => element.title == title)) {
      listTodo.add(item);
      isDuplicate.value = false;
    } else {
      isDuplicate.value = true;
    }
  }

  editItem(BuildContext context, int index, String editItem) {
    if (!listTodo.any((element) => element.title == editItem)) {
      final item = listTodo[index];
      item.title = editItem;
      listTodo[index] = item;
      isDuplicate.value = false;
      Navigator.pop(context);
    } else {
      isDuplicate.value = true;
    }
  }

  removeItem(int index) {
    listTodo.removeAt(index);
  }

  onComplete(int index) {
    final item = listTodo[index];
    item.isCompleted = !item.isCompleted!;
    listTodo[index] = item;
  }

  searchItem(String filter) {
    if (filter.isEmpty) {
      listFilter.value = listTodo;
    } else {}
    final result = listTodo
        .where(
          (value) => value.title!.toLowerCase().contains(
                filter.toLowerCase(),
              ),
        )
        .toList();
    listFilter.value = result;
  }
}
