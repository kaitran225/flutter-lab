import 'package:flutter/material.dart';
import 'package:lab12/models/task.dart';
import 'package:lab12/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _repository = TaskRepository();

  List<Task> get tasks => _repository.getTasks();

  void addTask(Task task) {
    _repository.addTask(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    _repository.updateTask(task);
    notifyListeners();
  }

  void deleteTask(String id) {
    _repository.deleteTask(id);
    notifyListeners();
  }

  void toggleTask(Task task) {
    final updatedTask = task.copyWith(completed: !task.completed);
    _repository.updateTask(updatedTask);
    notifyListeners();
  }
}
