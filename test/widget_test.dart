// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_practical_20/data/repositories/task_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late TaskRepository repository;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    repository = TaskRepository();
  });

  test('getTasks returns list of tasks', () async {
    when(mockDatabase.query('tasks')).thenAnswer((_) async => [
      {'id': 1, 'title': 'Test Task', 'is_completed': 0, 'created_at': '2023-10-01T00:00:00Z'},
    ]);
    when(mockDatabase.query('subtasks')).thenAnswer((_) async => []);

    final tasks = await repository.getTasks();

    expect(tasks.length, 1);
    expect(tasks[0].title, 'Test Task');
  });
}