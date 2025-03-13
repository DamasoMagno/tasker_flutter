class Task {
  final String name;
  final String description;

  Task({required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      name: map['name'],
      description: map['description'],
    );
  }
}