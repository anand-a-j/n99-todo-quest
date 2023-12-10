// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TodoModel {
  final int? id;
  String task;
  int isCompleted;

  TodoModel({
    this.id,
    required this.task,
    required this.isCompleted,
  });

  TodoModel copyWith({
    int? id,
    String? task,
    int? isCompleted,
  }) {
    return TodoModel(
      id: id ?? this.id,
      task: task ?? this.task,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'task': task,
      'isCompleted': isCompleted,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] != null ? map['id'] as int : null,
      task: map['task'] ?? '',
      isCompleted: map['isCompleted'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

}
