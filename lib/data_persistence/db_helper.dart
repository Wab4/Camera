import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'todo.dart';

class DBHelper {
  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'todo.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)',
        );
      },
    );
  }

  static Future<void> insertTodo(Todo todo) async {
    final db = await _initDB();
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateTodo(Todo todo) async {
    final db = await _initDB();
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  static Future<List<Todo>> getTodos() async {
    final db = await _initDB();
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(
      maps.length,
      (i) => Todo(id: maps[i]['id'], title: maps[i]['title']),
    );
  }

  static Future<void> deleteTodo(int id) async {
    final db = await _initDB();
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
