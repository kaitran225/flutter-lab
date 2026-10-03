import 'package:flutter/material.dart';
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'app_structure_theme.dart';
import 'common_ui_fixes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Biến quản lý trạng thái Dark Mode cho bài tập 4
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - Flutter UI Fundamentals',
      debugShowCheckedModeBanner: false,
      // Định nghĩa Theme cho ứng dụng
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: HomeScreen(onThemeChanged: toggleTheme, currentThemeMode: _themeMode),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final ThemeMode currentThemeMode;

  const HomeScreen({super.key, required this.onThemeChanged, required this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 4 – Flutter UI Fundament...')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuButton(context, 'Exercise 1 – Core Widgets Demo', (context) => const CoreWidgetsDemo()),
          _buildMenuButton(context, 'Exercise 2 – Input Controls Demo', (context) => const InputControlsDemo()),
          _buildMenuButton(context, 'Exercise 3 – Layout Demo', (context) => const LayoutDemo()),
          _buildMenuButton(context, 'Exercise 4 – App Structure & Theme', (context) => AppStructureTheme(onThemeChanged: onThemeChanged, currentThemeMode: currentThemeMode)),
          _buildMenuButton(context, 'Exercise 5 – Common UI Fixes', (context) => const CommonUIFixes()),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, WidgetBuilder builder) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: builder)),
      ),
    );
  }
}
