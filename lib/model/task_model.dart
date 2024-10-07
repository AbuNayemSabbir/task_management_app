import 'package:get/get.dart';

class TaskModel {
  int? id;
  String title;
  String details;
  DateTime dueDate;
  RxBool isCompleted;

  TaskModel({
    this.id,
    required this.title,
    required this.details,
    required this.dueDate,
    bool isCompleted = false,
  }) : isCompleted = RxBool(isCompleted);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted.value ? 1 : 0,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      details: map['details'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
