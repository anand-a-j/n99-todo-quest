import 'package:n99_todo/model/todo_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class TodoDatebase {
  /// Create Database-------------------------------------------------------------
  static Future<sql.Database> openDb() async {
    return sql.openDatabase('todo_db', version: 3,
        onCreate: ((db, version) async {
      await createTable(db);
    }));
  }

  /// Create Table--------------------------------------------------------------
  static Future<void> createTable(sql.Database db) async {
    await db.execute("""CREATE TABLE todo(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        task TEXT,
        isCompleted INTEGER
      )""");
  }

  /// Create Todo---------------------------------------------------------------
  static Future<int> createTodo(TodoModel todo) async {
    final db = await TodoDatebase.openDb();
    final id = db.insert('todo', {
      'task': todo.task,
      'isCompleted': todo.isCompleted,
    });
    return id;
  }

  /// Fetch all todos-----------------------------------------------------------
  static Future<List<TodoModel>> fetchAllTodos() async {
    final db = await TodoDatebase.openDb();
    final List<Map<String, dynamic>> results =
        await db.rawQuery("SELECT * FROM todo");
    List<TodoModel> data = [];
    for (var result in results) {
      data.add(TodoModel.fromMap(result));
    }
    return data;
  }

  /// updateTodoCompletion------------------------------------------------------
  static Future<void> updateTodoCompletion(int id, bool isCompleted) async {
    final db = await TodoDatebase.openDb();
    await db.update('todo', {'isCompleted': isCompleted ? 1 : 0},
        where: 'id=?', whereArgs: [id]);
  }

  /// Delete todo---------------------------------------------------------------
  static Future<void> deleteTodo(int id) async {
    final db = await TodoDatebase.openDb();
    await db.delete('todo', where: 'id=?', whereArgs: [id]);
  }

  /// Delete all todos----------------------------------------------------------
  static Future<void> deleteAllTodos() async {
    final db = await TodoDatebase.openDb();
    await db.delete('todo');
  }
}
