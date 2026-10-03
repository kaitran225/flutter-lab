import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 50.0;
  bool _isMovieActive = false;
  String _selectedGenre = 'None';
  DateTime? _selectedDate;

  // Hàm hiển thị DatePicker công khai và an toàn
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 2 – Input Contr...')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Slider section
          const Text('Rating (Slider)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Slider(
            value: _sliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            label: _sliderValue.round().toString(),
            onChanged: (value) {
              setState(() { _sliderValue = value; }); // Cập nhật state khi kéo slider
            },
          ),
          Text('Current value: ${_sliderValue.round()}'),
          const SizedBox(height: 20),

          // Switch section
          const Text('Active (Switch)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Is movie active?'),
            value: _isMovieActive,
            onChanged: (value) {
              setState(() { _isMovieActive = value; }); // Cập nhật state khi gạt switch
            },
          ),
          const SizedBox(height: 20),

          // RadioListTile section
          const Text('Genre (RadioListTile)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            title: const Text('Action'),
            value: 'Action',
            groupValue: _selectedGenre,
            onChanged: (value) {
              setState(() { _selectedGenre = value!; });
            },
          ),
          RadioListTile<String>(
            title: const Text('Comedy'),
            value: 'Comedy',
            groupValue: _selectedGenre,
            onChanged: (value) {
              setState(() { _selectedGenre = value!; });
            },
          ),
          Text('Selected genre: $_selectedGenre'),
          const SizedBox(height: 20),

          // Date Picker Button
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: const Text('Open Date Picker'),
          ),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
            ),
        ],
      ),
    );
  }
}