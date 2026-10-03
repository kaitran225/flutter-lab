class Task {
  final String id;
  String title;
  String description;
  bool completed;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
  });

  factory Task.create(String title, String description) {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
    );
  }

  void toggle() {
    completed = !completed;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, completed: $completed)';
  }
}