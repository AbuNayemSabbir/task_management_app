import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/task_model.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;

  late Database _database;

  @override
  void onInit() {
    super.onInit();
    initDatabase();
  }

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, details TEXT, dueDate TEXT, isCompleted INTEGER)',
        );
      },
      version: 1,
    );
    loadTasks(); // Load tasks after database initialization
  }

  // Load tasks from the database
  Future<void> loadTasks() async {
    final List<Map<String, dynamic>> taskMaps = await _database.query('tasks');
    tasks.assignAll(taskMaps.map((taskMap) => TaskModel.fromMap(taskMap)).toList());
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

  // Update task completion status
  Future<void> toggleTaskCompletion(int index) async {
    TaskModel task = tasks[index];
    task.isCompleted.value = !task.isCompleted.value;
    await _database.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    tasks[index] = task;
  }
}
