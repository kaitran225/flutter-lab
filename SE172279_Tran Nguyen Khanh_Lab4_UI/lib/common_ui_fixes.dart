import 'package:flutter/material.dart';

class CommonUIFixes extends StatefulWidget {
  const CommonUIFixes({super.key});

  @override
  State<CommonUIFixes> createState() => _CommonUIFixesState();
}

class _CommonUIFixesState extends State<CommonUIFixes> {
  // Danh sách phim ban đầu (Lỗi 3: Cần State để cập nhật UI)
  final List<String> _movies = [
    "Harry Potter and the Philosopher's Stone",
    'Harry Potter and the Chamber of Secrets',
    'Harry Potter and the Prisoner of Azkaban',
    'Harry Potter and the Goblet of Fire',
    'Harry Potter and the Order of the Phoenix',
    'Harry Potter and the Half-Blood Prince',
    'Harry Potter and the Deathly Hallows – Part 1',
    'Harry Potter and the Deathly Hallows – Part 2',
  ];

  void _addMovie() {
    // Lỗi 3: State không cập nhật nếu không dùng setState
    // Cách sửa: Bọc thao tác thay đổi dữ liệu trong setState(() { ... })
    setState(() {
      _movies.add('New Movie ${DateTime.now().second}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Common UI Fixes'),
      ),
      // Lỗi 2: Tràn màn hình (Overflow)
      // Cách sửa: Bọc layout bằng SingleChildScrollView để có thể cuộn khi nội dung quá dài
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh sách phim yêu thích:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Lỗi 1: ListView trong Column (Unbounded Height)
            // Triệu chứng: Gây lỗi RenderFlex children have non-zero flex
            // Cách sửa: Thêm shrinkWrap: true và physics: NeverScrollableScrollPhysics()
            ListView.builder(
              shrinkWrap: true, // Cho phép ListView chỉ chiếm không gian nó cần
              physics: const NeverScrollableScrollPhysics(), // Để Scroll của SingleChildScrollView quản lý
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.movie),
                    title: Text(_movies[index]),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Nút để thêm phim và minh họa việc cập nhật State
            Center(
              child: ElevatedButton.icon(
                onPressed: _addMovie,
                icon: const Icon(Icons.add),
                label: const Text('Add Movie (Requires setState)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Ghi chú về các lỗi UI:\n\n'
              '1. Unbounded Height: Xảy ra khi dùng ListView trong Column. Cách sửa là dùng shrinkWrap: true.\n\n'
              '2. Overflow: Xảy ra khi nội dung dài hơn màn hình. Cách sửa là dùng SingleChildScrollView.\n\n'
              '3. State Not Updating: Xảy ra khi thay đổi biến nhưng không gọi setState(). UI sẽ không vẽ lại nếu không có lệnh này.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
