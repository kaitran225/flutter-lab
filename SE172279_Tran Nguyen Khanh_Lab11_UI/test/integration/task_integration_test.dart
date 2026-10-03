import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lab11/main.dart';
import 'package:lab11/repositories/task_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('full task update flow', (WidgetTester tester) async {
      // Clear the repository to start fresh
      final repository = TaskRepository();
      repository.clear();

      // Build the app and wait for it to settle
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify we are on the task list screen
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);

      // Add a task with title "Original title"
      await tester.enterText(find.byType(TextField), 'Original title');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Verify the task appears in the list
      expect(find.text('Original title'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);

      // Tap the task to open the detail screen
      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();

      // Verify we are on the detail screen
      expect(find.text('Task Detail'), findsOneWidget);

      // Change the title to "Updated title"
      await tester.enterText(
          find.byKey(const Key('detailTitleField')), 'Updated title');
      // Tap the save button
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify we are back on the list screen
      expect(find.text('No tasks yet. Add one!'), findsNothing);
      // Verify the updated title appears in the list
      expect(find.text('Updated title'), findsOneWidget);
      expect(find.text('Original title'), findsNothing);
    });
  });
}