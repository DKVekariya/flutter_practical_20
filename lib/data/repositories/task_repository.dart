import '../database/database_helper.dart';
import '../models/subtask.dart';
import '../models/task.dart';

class TaskRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Task>> getTasks() async {
    final db = await _dbHelper.database;
    final taskMaps = await db.query('tasks');
    final subtaskMaps = await db.query('subtasks');

    return taskMaps.map((taskMap) {
      final subtasks = subtaskMaps
          .where((subtask) => subtask['task_id'] == taskMap['id'])
          .map((subtask) => Subtask(
        id: subtask['id'] as int,
        taskId: subtask['task_id'] as int,
        title: subtask['title'] as String,
        isCompleted: (subtask['is_completed'] as int) == 1,
      ))
          .toList();

      return Task(
        id: taskMap['id'] as int,
        title: taskMap['title'] as String,
        isCompleted: (taskMap['is_completed'] as int) == 1,
        createdAt: DateTime.parse(taskMap['created_at'] as String),
        subtasks: subtasks,
      );
    }).toList();
  }

  Future<void> addTask(Task task) async {
    final db = await _dbHelper.database;
    final taskId = await db.insert('tasks', {
      'title': task.title,
      'is_completed': task.isCompleted ? 1 : 0,
      'created_at': task.createdAt.toIso8601String(),
    });

    for (var subtask in task.subtasks) {
      await db.insert('subtasks', {
        'task_id': taskId,
        'title': subtask.title,
        'is_completed': subtask.isCompleted ? 1 : 0,
      });
    }
  }

  Future<void> updateTask(Task task) async {
    final db = await _dbHelper.database;
    await db.update(
      'tasks',
      {
        'title': task.title,
        'is_completed': task.isCompleted ? 1 : 0,
        'created_at': task.createdAt.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );

    await db.delete('subtasks', where: 'task_id = ?', whereArgs: [task.id]);
    for (var subtask in task.subtasks) {
      await db.insert('subtasks', {
        'task_id': task.id,
        'title': subtask.title,
        'is_completed': subtask.isCompleted ? 1 : 0,
      });
    }
  }

  Future<void> deleteTask(int taskId) async {
    final db = await _dbHelper.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
    await db.delete('subtasks', where: 'task_id = ?', whereArgs: [taskId]);
  }
}