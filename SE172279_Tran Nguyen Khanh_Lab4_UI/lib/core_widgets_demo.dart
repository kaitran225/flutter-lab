import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 1 – Core Widge...')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headline Text
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Material Icon
            const Center(
              child: Icon(
                Icons.airplay,
                size: 100,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),

            // Image.network
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://cacanhkimgiang.com/wp-content/uploads/2025/07/ca-phi-tan-trang.jpg', // Thay thế bằng link ảnh bất kỳ hợp lệ
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Card chứa ListTile
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.star, size: 30),
                title: const Text("Harry Potter and the Philosopher's Stone"),
                subtitle: const Text(
                  'Lab 5 sample movie — ListTile inside a Card (structure unchanged).',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}