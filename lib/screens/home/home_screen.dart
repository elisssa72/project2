import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todos/controllers/todo_controller.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/routes.dart';
import 'package:todos/utils/shared_prefs.dart';
import 'package:todos/widgets/Loader.dart';
import 'package:todos/widgets/custom_button.dart';
import 'package:todos/widgets/custom_search.dart';
import 'package:todos/widgets/custom_textfield.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'TODO',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 30,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => const Dialog(
                          child: ManipulateTodo(),    //didn't take parameter so edit =false so add action
                        ));
              },
              icon: const FaIcon(
                FontAwesomeIcons.plus,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Logout?"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () {
                            Navigator.pop(context);   //pop so go back to the todo page
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () async {
                            await SharedPrefs().removeUser();
                            Get.offAllNamed(GetRoutes.login);    //takes to login page
                          },
                          child: const Text("Confirm")),
                    ],
                  ),
                );
              },
              icon: const FaIcon(   //icon of logout
                FontAwesomeIcons.arrowRightFromBracket,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GetBuilder<TodoController>(builder: (controller) {
            return Column(
              children: [
                CustomSearch(onChanged: (val) {
                  controller.search(val);    // the search
                }),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                    child: SingleChildScrollView(  //allow scrolling
                  child: Column(
                    children: controller.filteredTodo
                        .map((todo) => Slidable(
                              child: TodoTile(todo: todo),
                              endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(  //edit label
                                      onPressed: (context) {
                                        controller.titleController.text =
                                            todo.title!;    //title
                                        controller.descriptionController.text =
                                            todo.description!;
                                        controller.update();
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: ManipulateTodo(
                                                      edit: true, id: todo.id!),
                                                ));
                                      }, //here for the edit we use the method to change it
                                      backgroundColor: const Color(0xff8394FF),
                                      foregroundColor: Colors.white,
                                      icon: FontAwesomeIcons.pencil,
                                      label: "Edit",
                                    ),
                                    SlidableAction(  //delete label
                                      onPressed: (context) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      "Delete Todo?"),
                                                  content: const Text(
                                                      "Are you sure you want to delete this todo?"),
                                                  actions: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary:
                                                                    Colors.red),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);  //if cancel go back but it stays
                                                        },
                                                        child: const Text(
                                                            "Cancel")),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          await Get.showOverlay(
                                                              asyncFunction: () =>
                                                                  controller
                                                                      .deleteTodo(todo
                                                                          .id!),
                                                              loadingWidget:
                                                                  const Loader());
                                                          Navigator.pop(
                                                              context); //go back and its been deleted
                                                        },
                                                        child: const Text(  //if delte
                                                            "Confirm")),
                                                  ],
                                                ));
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: FontAwesomeIcons.trash,
                                      label: "Delete",
                                    )
                                  ]),
                            ))
                        .toList(),
                  ),
                ))
              ],
            );
          }),
        ));
  }
}

class TodoTile extends StatelessWidget {   //design of each todo
  const TodoTile({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todo.title!,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 21,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            todo.date!,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xff000000),
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            todo.description!,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Color(0xff949494),
            ),
          )
        ],
      ),
    );
  }
}

class ManipulateTodo extends StatelessWidget {
  const ManipulateTodo({Key? key, this.edit = false, this.id = ""})  //for the edit
      : super(key: key);
  final bool edit;
  final String id;
  //for the edit  since add doesnt
  // change the edit it will be initially false so it will take the add action
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GetBuilder<TodoController>(builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${edit ? "Edit" : "Add"} Todo",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 21,
                color: Color(0xff000000),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomTextField(
                hint: "Title", controller: controller.titleController),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
                hint: "Description",
                maxLines: 5,
                controller: controller.descriptionController),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
                label: edit ? "Edit" : "Add",  //if label=edit
                onPressed: () async {
                  if (!edit) {  //if not edit so add
                    await Get.showOverlay(
                        asyncFunction: () => controller.addTodo(),  // go to add controller
                        loadingWidget: const Loader());
                  } else {
                    await Get.showOverlay(  //if edit
                        asyncFunction: () => controller.editTodo(id), //edit
                        loadingWidget: const Loader());
                  }
                  Navigator.pop(context);  //when edited or added go back
                }),
          ],
        );
      }),
    );
  }
}
