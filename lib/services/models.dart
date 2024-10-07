class Task {
  int id;
  String title;
  String note;
  bool isCompleted;
  DateTime date;
  String startTime;
  String endTime;
  int color;

  Task({
    required this.id,
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
  });

  // Factory method to create a Task from a map (for fetching from database)
  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      isCompleted: json['isCompleted'] == 1,  // Assuming SQLite returns 1 for true
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      color: json['color'],
    );
  }

  // Method to convert Task object to a map (for saving to the database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted == true ? 1 : 0,
      'date': date?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
    };
  }
}
