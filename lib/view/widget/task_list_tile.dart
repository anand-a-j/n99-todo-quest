import 'package:flutter/material.dart';
import 'package:n99_todo/controller/todo_provider.dart';
import 'package:n99_todo/model/todo_model.dart';

class TaskListTileWidget extends StatelessWidget {
  const TaskListTileWidget({
    super.key,
    required this.todo,
    required this.todoProvider,
  });

  final TodoModel todo;
  final TodoProvider todoProvider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.isCompleted == 1 ? true : false,
        onChanged: (value) {
          todo.isCompleted = value == true ? 1 : 0;
          todoProvider.updateIsCompleted(todo.id!, todo.isCompleted);
        },
      ),
      title: Text(
        todo.task,
        style: TextStyle(
          decoration: todo.isCompleted == 1
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          todoProvider.deleteTodo(todo.id!);
        },
        icon: Icon(
          Icons.delete,
          color: Colors.red.shade300,
        ),
      ),
    );
  }
}
