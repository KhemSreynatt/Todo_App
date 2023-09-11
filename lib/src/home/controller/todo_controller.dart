// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vtech_todo/src/home/model/todo_model.dart';

import '../custom/show_dailog.dart';

class TodoController extends GetxController {
  final searchText = "".obs;
  final isSearch = false.obs;
  final isCompeleted = false.obs;
  final isDuplicate = false.obs;
  final isNull = false.obs;
  final isNoData = false.obs;
  final confirmItem = ''.obs;
  final time = ''.obs;
  final listItem = <TodoModel>[].obs;
  final todoList = <TodoModel>[].obs;

  // final isLoading = false.obs;

  @override
  void onReady() {
    bindTodoStream();
  }

  bindTodoStream() async {
    todoList.bindStream(_todoStream());
  }

  //firebase
  Stream<List<TodoModel>> _todoStream() {
    return FirebaseFirestore.instance
        .collection('todos')
        .snapshots()
        .map((QuerySnapshot query) {
      final queryText = searchText.value;
      final shouldSearch = queryText.removeAllWhitespace.isNotEmpty;

      return query.docs
          .map((e) => TodoModel.fromDocumentSnapshot(documentSnapshot: e))
          .where((todo) {
        FirebaseFirestore.instance.collection('todos').orderBy('title').get();
        if (shouldSearch) {
          return todo.title.toLowerCase().contains(queryText.toLowerCase()) ||
              queryText.toLowerCase().contains(todo.title.toLowerCase());
        } else {
          return true;
        }
      }).toList();
    });
  }

  addTodo(TodoModel todo, BuildContext context) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('todos');

    QuerySnapshot querySnapshot =
        await collectionRef.where('title', isEqualTo: todo.title).get();

    if (querySnapshot.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('todos').add(
        {
          'title': todo.title,
          'time': todo.time,
          'isCompleted': false,
        },
      );
      isDuplicate.value = false; // print('Item added successfully!');
    } else {
      isDuplicate.value = true;
      // print('Item already exists!');

      onShowDuplicat(context);
    }
  }

  addDuplicat(TodoModel todo) async {
    await FirebaseFirestore.instance.collection('todos').add({
      'title': todo.title,
      'time': todo.time,
      'isCompleted': false,
    });
  }

  updateTitle(String newTitle, documentId) {
    FirebaseFirestore.instance.collection('todos').doc(documentId).update(
      {
        'title': newTitle,
      },
    );
  }

  deleteTodo(String documentId) {
    FirebaseFirestore.instance.collection('todos').doc(documentId).delete();
  }

  onCompleted(int index) {
    final todos = todoList[index];
    todos.iscompleted = !todos.iscompleted!;
    todoList[index] = todos;
  }
  //end
  // final listTodo = <TodoModel>[
  //   TodoModel(title: 'Flutter Dev'),
  //   TodoModel(
  //     title: 'Web Dev',
  //   )
  // ].obs;
  // final listFilter = <TodoModel>[].obs;

  // addItem(
  //   String title,
  //   String time,
  //   BuildContext context,
  // ) {
  //   final item = TodoModel(title: title, time: time);
  //   if (!listTodo.any((element) => element.title == title)) {
  //     listTodo.add(item);
  //     isDuplicate.value = false;
  //   } else {
  //     onShowDuplicat(context);
  //     isDuplicate.value = true;
  //     // listTodo.add(item);
  //   }
  // }

  // onConfirm(String? title, String? time) {
  //   final item = TodoModel(title: title, time: time);
  //   listTodo.add(item);
  // }

  // editItem(BuildContext context, int index, String editItem) {
  //   if (!listTodo.any((element) => element.title == editItem)) {
  //     final item = listTodo[index];
  //     item.title = editItem;
  //     listTodo[index] = item;
  //     isDuplicate.value = false;
  //     Navigator.pop(context);
  //   } else {
  //     isDuplicate.value = true;
  //   }
  // }

  // removeItem(int index) {
  //   listTodo.removeAt(index);
  // }

  // onComplete(int index) {
  //   final item = listTodo[index];
  //   item.isCompleted = !item.isCompleted!;
  //   listTodo[index] = item;
  // }

  // searchItem(String filter) {
  //   if (filter.isEmpty) {
  //     listFilter.value = listTodo;
  //   } else {}
  //   final result = listTodo
  //       .where(
  //         (value) => value.title!.toLowerCase().contains(
  //               filter.toLowerCase(),
  //             ),
  //       )
  //       .toList();
  //   listFilter.value = result;
  // }
}
