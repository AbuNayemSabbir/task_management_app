import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/task_model.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;
  var lists = <ListModel>[].obs;

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

  Future<void> loadLists() async {
    final List<Map<String, dynamic>> listMaps = await _database.query('lists');
    lists.assignAll(listMaps.map((listMap) => ListModel.fromMap(listMap)).toList());

    loadTasks();
  }

  Future<void> loadTasks() async {
    final List<Map<String, dynamic>> taskMaps = await _database.query('tasks');
    tasks.assignAll(taskMaps.map((taskMap) => TaskModel.fromMap(taskMap)).toList());
  }

  Future<int> addList(String title) async {
    final newList = ListModel(id: null, title: title);
    newList.id = await _database.insert('lists', newList.toMap());
    lists.add(newList);
    return newList.id!;
  }


  Future<void> addTask(TaskModel task) async {
    task.id = await _database.insert('tasks', task.toMap());
    tasks.add(task);
  }

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
    await _database.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    tasks[index] = task;
  }
  String getListTitle(int listId) {
    var list = lists.firstWhere(
          (list) => list.id == listId,
    );

    return list.title ?? 'Unknown List';
  }
}
