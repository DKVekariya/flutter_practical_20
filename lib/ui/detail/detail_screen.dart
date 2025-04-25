import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/subtask.dart';
import '../task_helper/task_provider.dart';
import '../ui_helper/gradient_button.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final int taskId;

  const DetailScreen({super.key, required this.taskId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late TextEditingController _titleController;
  late List<TextEditingController> _subtaskControllers;

  @override
  void initState() {
    super.initState();
    final task = ref.read(taskProvider).value!.firstWhere((t) => t.id == widget.taskId);
    _titleController = TextEditingController(text: task.title);
    _subtaskControllers = task.subtasks
        .map((subtask) => TextEditingController(text: subtask.title))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final task = ref.watch(taskProvider).value!.firstWhere((t) => t.id == widget.taskId);

    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.white), title: const Text('Edit Task'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 16),
            Text(
              'Created: ${DateFormat('MMM dd, yyyy - HH:mm').format(task.createdAt)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text('Subtasks', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._subtaskControllers.asMap().entries.map((entry) {
              final index = entry.key;
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: entry.value,
                      decoration: InputDecoration(labelText: 'Subtask ${index + 1}'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _subtaskControllers.removeAt(index);
                      });
                    },
                  ),
                ],
              );
            }),
            TextButton(
              onPressed: () {
                setState(() {
                  _subtaskControllers.add(TextEditingController());
                });
              },
              child: const Text('Add Subtask'),
            ),
            const SizedBox(height: 16),
            GradientButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  final updatedTask = task.copyWith(
                    title: _titleController.text,
                    subtasks: _subtaskControllers
                        .asMap()
                        .entries
                        .map((e) => Subtask(
                      id: task.subtasks.length > e.key
                          ? task.subtasks[e.key].id
                          : 0,
                      taskId: task.id,
                      title: e.value.text,
                      isCompleted: task.subtasks.length > e.key
                          ? task.subtasks[e.key].isCompleted
                          : false,
                    ))
                        .toList(),
                  );
                  ref.read(taskProvider.notifier).updateTask(updatedTask);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task updated')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task title is required')),
                  );
                }
              },
              text: 'Save',
            ),
          ],
        ),
      ),
    );
  }
}