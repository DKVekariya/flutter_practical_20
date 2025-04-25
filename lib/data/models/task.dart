import 'package:flutter_practical_20/data/models/subtask.dart';

class Task {
  final int id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
  final List<Subtask> subtasks;

  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
    required this.subtasks,
  });

  Task copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    List<Subtask>? subtasks,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}