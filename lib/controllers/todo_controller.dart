import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/models/user.dart';
import 'package:todos/utils/baseurl.dart';
import 'package:todos/utils/custom_snackbar.dart';
import 'package:todos/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class TodoController extends GetxController {
  List<Todo> todos = [];
  List<Todo> filteredTodo = [];

  late TextEditingController titleController, descriptionController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchMyTodos();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void onClose() {  //It disposes of the TextEditingController instances to avoid memory leaks.
    super.onClose();

    titleController.dispose();  //clean up
    descriptionController.dispose();
  }

  fetchMyTodos() async {
    var usr = await SharedPrefs().getUser();   //might take some time
    User user = User.fromJson(json.decode(usr));  //retrieve user info(decode json to dart)  //might take some time

    var response = await http
        .post(Uri.parse(baseurl + 'todos.php'), body: {"user_id": user.id});
    var res = await json.decode(response.body); //decode from json to dart

    if (res['success']) {
      todos = AllTodos.fromJson(res).todo!;
      filteredTodo = AllTodos.fromJson(res).todo!;
      update();
    } else {
      customSnackbar("Error", "Failed to fetch todos", "error");
    }
  }

  search(String val) {
    if (val.isEmpty) {  //if empty it shows all the list
      filteredTodo = todos;
      update();
      return;
    }

    filteredTodo = todos.where((todo) {
      return todo.title!.toLowerCase().contains(val.toLowerCase());  //filter acc to lower case
    }).toList();

    update();
  }

  addTodo() async {   // add to database
    var usr = await SharedPrefs().getUser();  //retrieve user info
    User user = User.fromJson(json.decode(usr));

    var response = await http.post(Uri.parse(baseurl + 'add_todo.php'), body: {
      "user_id": user.id,   //checks the user id
      "title": titleController.text,
      "description": descriptionController.text,
    }); //send to add.php(title desc and user id)

    var res = await json.decode(response.body);

    if (res['success']) {
      customSnackbar("Success", res['message'], "success");
      titleController.text = "";
      descriptionController.text = "";
      fetchMyTodos();
    } else {
      customSnackbar("Error", res['message'], "error");
    }
    update();
  }  //take note info and sends them to php which insert to the table

  editTodo(id) async {
    var usr = await SharedPrefs().getUser();
    User user = User.fromJson(json.decode(usr));

    var response = await http.post(Uri.parse(baseurl + 'edit_todo.php'), body: {
      "id": id,
      "user_id": user.id,
      "title": titleController.text,
      "description": descriptionController.text,
    });

    var res = await json.decode(response.body);

    if (res['success']) {
      customSnackbar("Success", res['message'], "success");
      titleController.text = "";
      descriptionController.text = "";
      fetchMyTodos();
    } else {
      customSnackbar("Error", res['message'], "error");
    }
    update();
  }
//go to edit which update
  deleteTodo(id) async {
    var usr = await SharedPrefs().getUser();
    User user = User.fromJson(json.decode(usr));

    var response =
        await http.post(Uri.parse(baseurl + 'delete_todo.php'), body: {
      "user_id": user.id,
      "id": id,
    });

    var res = await json.decode(response.body);

    if (res['success']) {
      customSnackbar("Success", res['message'], "success");
      fetchMyTodos();
    } else {
      customSnackbar("Error", res['message'], "error");
    }
    update();
  }
}
