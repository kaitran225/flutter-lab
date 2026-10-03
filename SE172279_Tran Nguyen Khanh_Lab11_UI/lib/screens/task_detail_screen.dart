import 'package:flutter/material.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task? task; // If null, we are creating a new task

  const TaskDetailScreen({super.key, this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TaskRepository _repository = TaskRepository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      // Show error? For now, just return.
      return;
    }
    setState(() => _isLoading = true);
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();

    if (widget.task == null) {
      // Creating a new task
      final Task newTask = Task.create(title, description);
      _repository.addTask(newTask);
    } else {
      // Updating existing task
      final Task updatedTask = Task(
        id: widget.task!.id,
        title: title,
        description: description,
        completed: widget.task!.completed,
      );
      _repository.updateTask(updatedTask);
    }
    // Ignore the result; we rely on the caller to update state via callback or by listening.
    // For simplicity, we'll just pop and let the parent handle refresh.
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Task Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const Key('detailTitleField'), // Key for testing
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
                // Allow multiple lines
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveTask,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}