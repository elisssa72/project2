class AllTodos {
  bool? success;
  String? message;
  List<Todo>? todo;

  AllTodos({this.success, this.message, this.todo});

  AllTodos.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      todo = <Todo>[];
      json['data'].forEach((v) {
        todo!.add(Todo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (todo != null) {
      data['data'] = todo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Todo {
  String? id;
  String? userId;
  String? title;
  String? description;
  String? date;

  Todo({this.id, this.userId, this.title, this.description, this.date});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    return data;
  }
}
