enum Recurrence { none, daily, weekly, monthly }

class Task {
  final String title;
  final String description;
  final DateTime reminderTime;
  final Recurrence recurrence;

  Task({
    required this.title,
    required this.description,
    required this.reminderTime,
    this.recurrence = Recurrence.none,
  });
}