import 'package:lab12/models/task.dart';

class TaskRepository {
  final List<Task> _tasks = [];

  TaskRepository._internal();

  static final TaskRepository _instance = TaskRepository._internal();

  factory TaskRepository() => _instance;

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(Task task) {
    _tasks.add(task);
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }

  List<Task> getTasks() => List.unmodifiable(_tasks);

  // For testing purposes, we allow clearing the list
  void clear() {
    _tasks.clear();
  }
}