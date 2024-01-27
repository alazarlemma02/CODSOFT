import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_app/data/model/task.dart';
import 'package:task_app/data/model/task_fields.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _database;
  DatabaseProvider._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT  NOT NULL,
      isCompleted INTEGER NOT NULL,
      createdAt TEXT NOT NULL,
      completedAt TEXT,
      timeRangeStart INTEGER,
      timeRangeEnd INTEGER
    )
  ''');
  }

  // CRUD
  //create
  Future<Task> create(Task task) async {
    final db = await instance.database;
    final id = await db.insert("tasks", task.toMap());
    return task.copyWith(id: id);
  }

  //readTask
  Future<Task> readTask({required int id}) async {
    final db = await instance.database;
    final maps = await db.query("tasks",
        columns: TaskFields.values,
        where: '${TaskFields.values[0]} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  //readALl
  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    final orderBy = '${TaskFields.values[4]} ASC';
    final result = await db.query("tasks", orderBy: orderBy);
    return result.map((json) => Task.fromMap(json)).toList();
  }

  //update

  Future<int> update({required Task task}) async {
    final db = await instance.database;
    return db.update("tasks", task.toMap(),
        where: '${TaskFields.values[0]} = ?', whereArgs: [task.id]);
  }

  // delete
  Future<int> delete({required int id}) async {
    final db = await instance.database;
    return db
        .delete("tasks", where: '${TaskFields.values[0]} = ?', whereArgs: [id]);
  }

  //filter
  Future<List<Task>> filter(
      {required String filterKey, required dynamic filterValue}) async {
    final db = await instance.database;
    List<Map<String, dynamic>> tasks = await db.query("tasks",
        where: '$filterKey = ?',
        whereArgs: [filterValue],
        orderBy: 'createdAt ASC');
    return tasks.map((json) => Task.fromMap(json)).toList();
  }

  //delete all
  Future<int> deleteAll() async {
    final db = await instance.database;
    return db.delete("tasks");
  }

  // delete completed
  Future<int> deleteCompleted() async {
    final db = await instance.database;
    return db.delete("tasks", where: 'isCompleted = ?', whereArgs: [1]);
  }

  // delete pending
  Future<int> deletePending() async {
    final db = await instance.database;
    return db.delete("tasks", where: 'isCompleted = ?', whereArgs: [0]);
  }

  // close
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
