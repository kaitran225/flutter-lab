import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lab12/main.dart';
import 'package:lab12/providers/task_provider.dart';

void main() {
  testWidgets('Taskly loads list screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TaskProvider(),
        child: const MyApp(),
      ),
    );
    expect(find.text('Taskly'), findsOneWidget);
    expect(find.text('No tasks yet. Add one!'), findsOneWidget);
  });
}
