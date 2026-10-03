import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Movie list data (same titles/overviews as Lab 5 sample_data — structure unchanged: List<Map>)
    final List<Map<String, String>> movies = [
      {
        'title': "Harry Potter and the Philosopher's Stone",
        'desc':
            'An orphaned boy enrolls in a school of wizardry, where he learns the truth about himself, his family and the terrible evil that haunts the magical world.',
      },
      {
        'title': 'Harry Potter and the Chamber of Secrets',
        'desc':
            'An ancient prophecy seems to be coming true when a mysterious presence begins stalking the corridors of a school of magic and leaving its victims paralyzed.',
      },
      {
        'title': 'Harry Potter and the Prisoner of Azkaban',
        'desc':
            'Harry Potter, Ron and Hermione return to Hogwarts for their third year, facing an escaped prisoner who threatens the young wizard.',
      },
      {
        'title': 'Harry Potter and the Goblet of Fire',
        'desc':
            'Harry finds himself competing in a hazardous tournament between rival schools of magic, distracted by recurring nightmares.',
      },
      {
        'title': 'Harry Potter and the Order of the Phoenix',
        'desc':
            'Harry and Dumbledore are targeted by Wizard authorities as an authoritarian bureaucrat slowly seizes power at Hogwarts.',
      },
      {
        'title': 'Harry Potter and the Half-Blood Prince',
        'desc':
            'Harry discovers an old book marked as "the property of the Half-Blood Prince" and learns more about Voldemort\'s dark past.',
      },
      {
        'title': 'Harry Potter and the Deathly Hallows – Part 1',
        'desc':
            'Harry, Ron and Hermione race to destroy the Horcruxes and uncover the three Deathly Hallows.',
      },
      {
        'title': 'Harry Potter and the Deathly Hallows – Part 2',
        'desc':
            'The final battle: Harry, Ron and Hermione fight to vanquish Voldemort once and for all.',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 3 – Layout De...')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical layout section bằng Column & Padding
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'Now Playing',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Sử dụng Expanded để ListView.builder chiếm trọn không gian còn lại một cách an toàn
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0), // Khoảng cách đều giữa các dòng
                  child: Card(
                    elevation: 1,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(movies[index]['title']![0]), // Lấy chữ cái đầu tiên
                      ),
                      title: Text(movies[index]['title']!),
                      subtitle: Text(movies[index]['desc']!),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}