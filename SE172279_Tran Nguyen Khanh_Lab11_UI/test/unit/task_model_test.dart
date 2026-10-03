import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  group('Task', () {
    test('default completed value is false', () {
      final task = Task.create('Test Title', '');
      expect(task.completed, isFalse);
    });

    test('toggle switches completed value', () {
      final task = Task.create('Test Title', '');
      expect(task.completed, isFalse);
      task.toggle();
      expect(task.completed, isTrue);
      task.toggle();
      expect(task.completed, isFalse);
    });
  });
}