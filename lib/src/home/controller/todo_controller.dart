import 'package:get/get.dart';

class TodoController extends GetxController {
  final isSearch = false.obs;

  final listTodo = ["Flutter Dev", "Web Dev", "Mobile Dev"].obs;
  final listSearch = <String>[].obs;
  //List<String> get todos => listTodo.toList();

  addTodo(String todo) {
    listTodo.add(todo);
  }

  updateTodoAt(int index, String newTodo) {
    listTodo[index] = newTodo;
  }

  removeTodoAt(int index) {
    listTodo.removeAt(index);
  }

  filterList(String searchQuery) {
    listTodo
        .where((value) => value.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ))
        .toList();
    listSearch.add(listTodo.toString());
  }
}
