class Task {
  final String id;
  final String title;
  final String description;
  final bool completed;

  const Task({
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

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.completed == completed;
  }

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ description.hashCode ^ completed.hashCode;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, completed: $completed)';
  }
}
