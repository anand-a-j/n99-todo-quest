import 'package:flutter/material.dart';
import 'package:n99_todo/controller/todo_provider.dart';
import 'package:provider/provider.dart';
import 'widget/task_list_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).getAllTodo();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, _) {
          return todoProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : todoProvider.todos.isEmpty
                  ? const Center(
                      child: Text(
                        "Task not added\nTap + to add new task",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: todoProvider.todos.length,
                      itemBuilder: (context, index) {
                        var todo = todoProvider.todos[index];
                        return TaskListTileWidget(
                          todo: todo,
                          todoProvider: todoProvider,
                        );
                      },
                    );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodoAlertDialogBox(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> addTodoAlertDialogBox(BuildContext context) async {
    var todoProvider = context.read<TodoProvider>();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter your task'),
          content: TextField(
            controller: todoProvider.taskController,
            decoration: const InputDecoration(hintText: "Task"),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                todoProvider.addTodo(context);
              },
              child: const Text("Add"),
            )
          ],
        );
      },
    );
  }
}
