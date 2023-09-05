// ignore_for_file: deprecated_member_use, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/todo_controller.dart';
import '../custom/show_dailog.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen({super.key});
  final TodoController todoController = Get.put(TodoController());
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _todoControllerSearch = TextEditingController();
  String? text;

  onSetTodo(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('title', title);
  }

  @override
  Widget build(BuildContext context) {
    var nows = DateTime.now();
    var formatter = DateFormat().add_jm();
    String formattedDate = formatter.format(nows);

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
                      todoController.searchItem(e);
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
                todoController.searchItem("");
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
            //Text(formattedDate),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  todoController.isSearch.value == true
                      ? const SizedBox()
                      : Expanded(
                          child: TextFormField(
                            controller: _todoController,
                            autofocus: true,
                            onTap: () {
                              todoController.isNull.value = false;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: todoController.isNull.value == true
                                  ? "Empty item"
                                  : todoController.isDuplicate.value == true
                                      ? 'Item is duplicate'
                                      : 'Add a item ',
                              labelStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: todoController.isNull.value == true ||
                                        todoController.isDuplicate.value == true
                                    ? Colors.red
                                    : Colors.blueGrey,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  final newTodo = _todoController.text.trim();
                                  todoController.confirmItem.value = newTodo;
                                  todoController.time.value = formattedDate;
                                  if (newTodo.isNotEmpty) {
                                    todoController.addItem(newTodo,
                                        todoController.time.value, context);
                                    _todoController.clear();
                                    todoController.isNull.value = false;
                                  } else {
                                    todoController.isNull.value = true;
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
                                borderSide: BorderSide(
                                  color: todoController.isNull.value == true ||
                                          todoController.isDuplicate.value ==
                                              true
                                      ? Colors.red
                                      : Colors.blueGrey,
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
                () => todoController.isSearch.value == true &&
                        todoController.listFilter.isEmpty
                    ? Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          margin: const EdgeInsets.only(bottom: 100),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                                image: AssetImage("assets/png/no_data.jpeg")),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: todoController.isSearch.value
                            ? todoController.listFilter.length
                            : todoController.listTodo.length,
                        itemBuilder: (BuildContext context, int index) {
                          final todo = todoController.isSearch.value
                              ? todoController.listFilter[index]
                              : todoController.listTodo[index];

                          return Container(
                            margin: const EdgeInsets.only(
                                left: 8, right: 8, top: 8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.grey.withOpacity(0.2))),
                            child: ListTile(
                              title: Obx(
                                () => Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        todoController.onComplete(index);
                                      },
                                      child: todoController.listTodo[index]
                                                  .isCompleted ==
                                              false
                                          ? SvgPicture.asset(
                                              'assets/svg/circle.svg',
                                              color: Colors.blueGrey,
                                            )
                                          : SvgPicture.asset(
                                              'assets/svg/Check_done.svg',
                                              color: Colors.blueGrey,
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${todo.title}",
                                      style: TextStyle(
                                        decoration: todoController
                                                    .listTodo[index]
                                                    .isCompleted ==
                                                false
                                            ? TextDecoration.none
                                            : TextDecoration.lineThrough,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${todo.time == null || todo.time == '' ? '' : todo.time}",
                                      style: TextStyle(
                                        decoration: todoController
                                                    .listTodo[index]
                                                    .isCompleted ==
                                                false
                                            ? TextDecoration.none
                                            : TextDecoration.lineThrough,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      todoController.isDuplicate.value = false;
                                      onShowEditDialog(
                                        context,
                                        todoController,
                                        index,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(7),
                                      height: 34,
                                      width: 34,
                                      child: SvgPicture.asset(
                                          'assets/svg/edit.svg'),
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
                                        todoController.removeItem(index);
                                      },
                                      child: SvgPicture.asset(
                                          'assets/svg/delete.svg'),
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
