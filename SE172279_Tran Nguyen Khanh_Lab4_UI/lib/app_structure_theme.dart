import 'package:flutter/material.dart';

class AppStructureTheme extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final ThemeMode currentThemeMode;

  const AppStructureTheme({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem hiện tại có đang là Dark Mode không
    bool isDarkMode = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Structure & Theme'),
        actions: [
          // Widget Switch để chuyển đổi Dark Mode
          Row(
            children: [
              const Text('Dark'),
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  // Gọi callback function được truyền từ main.dart
                  onThemeChanged(value);
                },
              ),
            ],
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Giao diện hiện tại:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Thử gạt Switch ở trên để đổi Theme!',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
      // FloatingActionButton với icon dấu cộng
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Hiển thị SnackBar khi nhấn vào FAB
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bạn vừa nhấn vào FloatingActionButton!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
