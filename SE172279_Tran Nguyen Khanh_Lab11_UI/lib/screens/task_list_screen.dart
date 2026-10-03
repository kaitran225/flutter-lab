import 'package:flutter/material.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskRepository _repository = TaskRepository();
  final TextEditingController _controller = TextEditingController();
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _repository.getTasks().toList();
  }

  void _addTask() {
    final String title = _controller.text.trim();
    if (title.isEmpty) return;
    final Task newTask = Task.create(title, '');
    _repository.addTask(newTask);
    setState(() {
      _tasks = _repository.getTasks().toList();
    });
    _controller.clear();
  }

  void _updateTask(Task updatedTask) {
    _repository.updateTask(updatedTask);
    setState(() {
      _tasks = _repository.getTasks().toList();
    });
  }

  void _deleteTask(String id) {
    _repository.deleteTask(id);
    setState(() {
      _tasks = _repository.getTasks().toList();
    });
  }

  void _navigateToDetail([Task? task]) async {
    await Navigator.of(context).push<Task>(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
    if (!mounted) return;
    setState(() {
      _tasks = _repository.getTasks().toList();
    });
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
            child: _tasks.isEmpty
                ? const Center(
                    child: Text('No tasks yet. Add one!'),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Dismissible(
                        key: Key(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteTask(task.id),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.completed,
                            onChanged: (_) => _toggleTask(task),
                          ),
                          title: Text(task.title),
                          subtitle: task.description.isNotEmpty
                              ? Text(task.description)
                              : null,
                          onTap: () => _navigateToDetail(task),
                        ),
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

  void _toggleTask(Task task) {
    final toggled = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      completed: !task.completed,
    );
    _updateTask(toggled);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}