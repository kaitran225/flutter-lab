import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  setUp(() {
    // Clear the repository before each test
    final repository = TaskRepository();
    repository.clear();
  });

  testWidgets('TaskListScreen shows empty state message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: TaskListScreen(),
    ));

    expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('TaskListScreen allows adding a task via input field and button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: TaskListScreen(),
    ));

    // Enter text in the text field
    await tester.enterText(find.byType(TextField), 'New Task');
    // Tap the add button
    await tester.tap(find.text('Add'));
    // Rebuild the widget
    await tester.pump();

    // Verify the task appears in the list
    expect(find.text('New Task'), findsOneWidget);
    expect(find.text('No tasks yet. Add one!'), findsNothing);
  });

  testWidgets('TaskListScreen displays multiple tasks', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: TaskListScreen(),
    ));

    // Add first task
    await tester.enterText(find.byType(TextField), 'Task 1');
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Add second task
    await tester.enterText(find.byType(TextField), 'Task 2');
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Verify both tasks are visible
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
  });
}