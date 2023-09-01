import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controller/todo_controller.dart';
import '../custom/show_dailog.dart';

class TodoScreen extends StatelessWidget {
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _todoControllerSearch = TextEditingController();
  TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.put(TodoController());

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          elevation: 0.2,
          title: todoController.isSearch.value == true
              ? SizedBox(
                  height: 50,
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (e) {
                      todoController.filterList(e);
                    },
                    controller: _todoControllerSearch,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Search List',
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          todoController.isSearch.value = false;
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/svg/cancel.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : const Text('Todo List'),
          actions: [
            GestureDetector(
              onTap: () {
                todoController.isSearch.value = true;
                todoController.filterList("");
              },
              child: SvgPicture.asset('assets/svg/search.svg'),
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  todoController.isSearch.value == true
                      ? const SizedBox()
                      : Expanded(
                          child: TextFormField(
                            controller: _todoController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: 'Add a item ',
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  final newTodo = _todoController.text.trim();
                                  if (newTodo.isNotEmpty) {
                                    todoController.addTodo(newTodo);
                                    _todoController.clear();
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  child: SvgPicture.asset(
                                    'assets/svg/plus-circle.svg',
                                    height: 20,
                                    width: 20,
                                    color: Colors.blueGrey,
                                  ),
                                ),
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
                        ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "All Todo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: todoController.isSearch.value
                      ? todoController.listSearch.length
                      : todoController.listTodo.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todo = todoController.isSearch.value
                        ? todoController.listSearch[index]
                        : todoController.listTodo[index];
                    return Container(
                      margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1, color: Colors.grey.withOpacity(0.2))),
                      child: ListTile(
                        title: Text(
                          todo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                onShowEditDialog(
                                  context,
                                  todoController,
                                  index,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.all(7),
                                height: 34,
                                width: 34,
                                child: SvgPicture.asset('assets/svg/edit.svg'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(7),
                              child: GestureDetector(
                                onTap: () {
                                  todoController.removeTodoAt(index);
                                },
                                child:
                                    SvgPicture.asset('assets/svg/delete.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
