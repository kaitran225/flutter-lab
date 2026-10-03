import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lab12/models/task.dart';
import 'package:lab12/providers/task_provider.dart';
import 'package:lab12/screens/task_detail_screen.dart';
import 'package:lab12/widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache the task icon for better performance (Exercise 12.2)
    precacheImage(const AssetImage('assets/images/task_icon.png'), context);
  }

  void _addTask() {
    final String title = _controller.text.trim();
    if (title.isEmpty) return;
    final Task newTask = Task.create(title, '');
    context.read<TaskProvider>().addTask(newTask);
    _controller.clear();
  }

  void _navigateToDetail([Task? task]) async {
    // We don't necessarily need the result if TaskDetailScreen uses the provider
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
      ),
      body: Column(
        children: [
          _buildInputSection(),
          Expanded(
            child: Selector<TaskProvider, List<Task>>(
              selector: (_, provider) => provider.tasks,
              builder: (context, tasks, child) {
                if (tasks.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image: AssetImage('assets/images/task_icon.png'),
                          width: 64,
                          height: 64,
                        ),
                        SizedBox(height: 12),
                        Text('No tasks yet. Add one!'),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
                      key: ValueKey(task.id),
                      task: task,
                      onToggle: () =>
                          context.read<TaskProvider>().toggleTask(task),
                      onDelete: () =>
                          context.read<TaskProvider>().deleteTask(task.id),
                      onTap: () => _navigateToDetail(task),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addTask(),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _addTask,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
