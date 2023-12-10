import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:n99_todo/database/todo_db.dart';
import 'package:n99_todo/model/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<TodoModel> _todos = [];
  final TextEditingController _taskController = TextEditingController();

  bool get isLoading => _isLoading;
  List<TodoModel> get todos => _todos;
  TextEditingController get taskController => _taskController;

// add todo---------------------------------------------------------------------
  addTodo(BuildContext context) async {
    int? id;

    _isLoading = true;
    notifyListeners();

    if (_taskController.text.isNotEmpty) {
      TodoModel todo = TodoModel(
        task: _taskController.text,
        isCompleted: 0,
      );

      id = await TodoDatebase.createTodo(todo);

      if (id.toString().isNotEmpty) {
        Fluttertoast.showToast(msg: 'Task added successfully');
        await getAllTodo();
        if (context.mounted) Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong, try again!!!');
      }
    } else {
      Fluttertoast.showToast(msg: 'Enter your task');
    }

    _isLoading = false;
    notifyListeners();
  }

// get all todo-----------------------------------------------------------------
  getAllTodo() async {
    _isLoading = true;
    notifyListeners();

    _todos = await TodoDatebase.fetchAllTodos();

    _isLoading = false;
    notifyListeners();
  }

// update is completed----------------------------------------------------------
  updateIsCompleted(int id, int isCompleted) async {
    try {
      await TodoDatebase.updateTodoCompletion(id, isCompleted == 1 ? true : false);
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: 'something went wrong');
    }
  }

// delete todo------------------------------------------------------------------
  void deleteTodo(int id) async {
    try {
      await TodoDatebase.deleteTodo(id);
      Fluttertoast.showToast(msg: 'Task deleted successfully');
      getAllTodo();
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  /// Delete all todos----------------------------------------------------------
  static Future<void> deleteAllTodos() async {
    final db = await TodoDatebase.openDb();
    await db.delete('todo');
  }
}
