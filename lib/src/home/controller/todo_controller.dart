import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vtech_todo/src/home/model/todo_model.dart';

import '../custom/show_dailog.dart';

class TodoController extends GetxController {
  final isSearch = false.obs;
  final isCompele = false.obs;
  final isDuplicate = false.obs;
  final isNull = false.obs;
  final confirmItem = ''.obs;
  final time = ''.obs;
  final listItem = <TodoModel>[].obs;

  //firebase

  //end
  final listTodo = <TodoModel>[
    TodoModel(title: 'Flutter Dev'),
    TodoModel(
      title: 'Web Dev',
    )
  ].obs;
  final listFilter = <TodoModel>[].obs;

  addItem(
    String title,
    String time,
    BuildContext context,
  ) {
    final item = TodoModel(title: title, time: time);
    if (!listTodo.any((element) => element.title == title)) {
      listTodo.add(item);
      isDuplicate.value = false;
    } else {
      onShowDuplicat(context);
      isDuplicate.value = true;
      // listTodo.add(item);
    }
  }

  onConfirm(String? title, String? time) {
    final item = TodoModel(title: title, time: time);
    listTodo.add(item);
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
