import 'package:get/get.dart';
class ListModel {
  int? id;
  String title;

  ListModel({
    this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      id: map['id'],
      title: map['title'],
    );
  }
}

class TaskModel {
  int? id;
  String title;
  String details;
  DateTime dueDate;
  RxBool isCompleted;
  int listId; /// This will reference the ListModel ID

  TaskModel({
    this.id,
    required this.title,
    required this.details,
    required this.dueDate,
    required this.listId,
    bool isCompleted = false,
  }) : isCompleted = RxBool(isCompleted);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted.value ? 1 : 0,
      'listId': listId,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      details: map['details'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      listId: map['listId'],
    );
  }
}
