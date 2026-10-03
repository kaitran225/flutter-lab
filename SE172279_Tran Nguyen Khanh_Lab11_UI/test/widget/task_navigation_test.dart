import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  setUp(() {
    // Clear the repository before each test
    final repository = TaskRepository();
    repository.clear();
  });

  testWidgets('TaskListScreen navigates to TaskDetailScreen when a task is tapped',
      (WidgetTester tester) async {
    // Seed the repository with a task
    final repository = TaskRepository();
    final task = Task.create('Test Task', 'Test Description');
    repository.addTask(task);

    // Pump the TaskListScreen
    await tester.pumpWidget(const MaterialApp(
      home: TaskListScreen(),
    ));

    // Verify the task is listed
    expect(find.text('Test Task'), findsOneWidget);

    // Tap the task item (ListTile)
    await tester.tap(find.byType(ListTile).first);
    // Wait for the navigation animation to complete
    await tester.pumpAndSettle();

    // Verify we are on the detail screen (rubric AppBar title)
    expect(find.text('Task Detail'), findsOneWidget);
    // Verify the title text field has the correct key and displays the task title
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
    final TextField titleField =
        tester.widget(find.byKey(const Key('detailTitleField')));
    expect(titleField.controller!.text, equals('Test Task'));
  });
}
