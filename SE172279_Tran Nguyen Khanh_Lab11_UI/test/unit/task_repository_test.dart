import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/models/task.dart';

void main() {
  late TaskRepository repository;

  setUp(() {
    repository = TaskRepository();
    repository.clear();
  });

  group('TaskRepository', () {
    test('addTask increases task count and contains the task', () {
      final task = Task.create('Test Title', 'Test Description');
      expect(repository.tasks.length, equals(0));
      repository.addTask(task);
      expect(repository.tasks.length, equals(1));
      expect(repository.tasks.contains(task), isTrue);
    });

    test('deleteTask removes the task', () {
      final task = Task.create('Test Title', 'Test Description');
      repository.addTask(task);
      expect(repository.tasks.length, equals(1));
      repository.deleteTask(task.id);
      expect(repository.tasks.length, equals(0));
      expect(repository.tasks.contains(task), isFalse);
    });

    test('updateTask modifies the task', () {
      final task = Task.create('Old Title', 'Old Description');
      repository.addTask(task);
      final updatedTask = Task(
        id: task.id,
        title: 'New Title',
        description: 'New Description',
        completed: true,
      );
      repository.updateTask(updatedTask);
      final retrieved = repository.tasks.firstWhere((t) => t.id == task.id);
      expect(retrieved.title, equals('New Title'));
      expect(retrieved.description, equals('New Description'));
      expect(retrieved.completed, isTrue);
    });

    test('getTasks returns unmodifiable list', () {
      final task = Task.create('Test', '');
      repository.addTask(task);
      expect(() => repository.tasks.add(Task.create('Should fail', '')),
          throwsUnsupportedError);
    });
  });
}