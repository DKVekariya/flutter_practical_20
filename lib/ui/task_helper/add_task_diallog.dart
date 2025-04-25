import 'package:flutter/material.dart';
import 'package:flutter_practical_20/ui/task_helper/task_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/subtask.dart';
import '../../data/models/task.dart';
import '../ui_helper/gradient_button.dart';

class AddTaskDialog extends ConsumerStatefulWidget {
  const AddTaskDialog({super.key});

  @override
  ConsumerState<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends ConsumerState<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _subtasks = <String>[];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 16),
            ..._subtasks.asMap().entries.map((entry) {
              final index = entry.key;
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Subtask ${index + 1}'),
                      onChanged: (value) => _subtasks[index] = value,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() => _subtasks.removeAt(index));
                    },
                  ),
                ],
              );
            }),
            TextButton(
              onPressed: () {
                setState(() => _subtasks.add(''));
              },
              child: const Text('Add Subtask'),
            ),
          ],
        ),
      ),
      actions: [
        GradientButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              final task = Task(
                id: 0,
                title: _titleController.text,
                isCompleted: false,
                createdAt: DateTime.now(),
                subtasks: _subtasks
                    .asMap()
                    .entries
                    .map((e) => Subtask(
                  id: 0,
                  taskId: 0,
                  title: e.value,
                  isCompleted: false,
                ))
                    .toList(),
              );
              ref.read(taskProvider.notifier).addTask(task);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task title is required')),
              );
            }
          },
          text: 'Save',
        ),
      ],
    );
  }
}