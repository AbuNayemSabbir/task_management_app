import 'dart:async';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/services/notification_services.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;
  var lists = <ListModel>[].obs;
  final NotificationService notificationService = NotificationService();

  late Database _database;

  @override
  @override
  void onInit() {
    super.onInit();

    // Initialize the database
    initDatabase();

    // Initialize the notification service
    notificationService.initNotification();

    // Check for overdue tasks immediately
    checkForDueTasks();

    // Periodically check every 10 seconds for testing
    Timer.periodic(const Duration(hours: 24), (timer) {
      checkForDueTasks();
    });
  }


  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, details TEXT, dueDate TEXT, isCompleted INTEGER, listId INTEGER)',
        );
        db.execute(
          'CREATE TABLE lists(id INTEGER PRIMARY KEY, title TEXT)',
        );
      },
      version: 1,
    );
    loadLists();
  }

  // Getter to calculate total incomplete tasks
  int get totalIncompleteTasks => tasks.where((task) => task.isCompleted.value == false).length;

  // Getter to calculate total completed tasks
  int get totalCompletedTasks => tasks.where((task) => task.isCompleted.value == true).length;

  // Method to update the due date of a task
  Future<void> updateDueDate(int taskId, DateTime newDueDate) async {
    await _database.update(
      'tasks',
      {'dueDate': newDueDate.toIso8601String()},
      where: 'id = ?',
      whereArgs: [taskId],
    );
    loadTasks();
  }

  // Method to update the description of a task
  Future<void> updateDescription(int taskId, String details) async {
    await _database.update(
      'tasks',
      {'details': details},
      where: 'id = ?',
      whereArgs: [taskId],
    );
    loadTasks();
  }

  // Fetch a task by its ID
  TaskModel getTaskById(int taskId) {
    return tasks.firstWhere((task) => task.id == taskId, orElse: () => throw Exception("Task not found"));
  }

  // Load all lists from the database
  Future<void> loadLists() async {
    final List<Map<String, dynamic>> listMaps = await _database.query('lists');
    lists.assignAll(listMaps.map((listMap) => ListModel.fromMap(listMap)).toList());
    loadTasks();
  }

  // Load all tasks from the database
  Future<void> loadTasks() async {
    final List<Map<String, dynamic>> taskMaps = await _database.query('tasks');
    tasks.assignAll(taskMaps.map((taskMap) => TaskModel.fromMap(taskMap)).toList());
  }

  // Add a new list
  Future<int> addList(String title) async {
    final newList = ListModel(id: null, title: title);
    newList.id = await _database.insert('lists', newList.toMap());
    lists.add(newList);
    return newList.id!;
  }

  // Add a new task
  Future<void> addTask(TaskModel task) async {
    task.id = await _database.insert('tasks', task.toMap());
    tasks.add(task);
  }

  // Remove a task
  Future<void> removeTask(int id) async {
    await _database.delete('tasks', where: 'id = ?', whereArgs: [id]);
    tasks.removeWhere((task) => task.id == id);
  }

  Future<void> removeList(int listId) async {
    await _database.delete('tasks', where: 'listId = ?', whereArgs: [listId]);
    await _database.delete('lists', where: 'id = ?', whereArgs: [listId]);
    lists.removeWhere((list) => list.id == listId);
    loadTasks();
  }


  Future<void> toggleTaskCompletion(int index) async {
    TaskModel task = tasks[index];
    task.isCompleted.value = !task.isCompleted.value;
    await _database.update(
      'tasks',
      {
        'isCompleted': task.isCompleted.value ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
    tasks[index] = task;
  }


  // Get the title of a list by its ID
  String getListTitle(int listId) {
    var list = lists.firstWhere((list) => list.id == listId, orElse: () => ListModel(title: 'Unknown List'));
    return list.title ?? 'Unknown List';
  }

  void checkForDueTasks() {
    final now = DateTime.now();
    print('now time: $now');

    for (var task in tasks) {
      final dueDate = task.dueDate;
      print('due time: $dueDate');

      if (dueDate.isBefore(now) && !task.isCompleted.value) {
        // Show notification for overdue tasks
        notificationService.showNotification(
          task.id!,
          'Task Overdue',
          'Your task "${task.title}" is overdue!',
        );
      }
    }
  }

}
