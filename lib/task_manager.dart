import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:memento/model/task.dart';
import 'package:memento/task_creator.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  _TaskManagerScreenState createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final List<Task> _tasks = [];
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();



  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
    _scheduleNotification(task);
  }

  void _deleteTask(int index) {
    HapticFeedback.mediumImpact(); // iOS Haptic Feedback
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _scheduleNotification(Task task) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'This channel is for task reminders.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    tz.TZDateTime scheduleTime = tz.TZDateTime.from(task.reminderTime, tz.local);

    if (task.recurrence == Recurrence.none) {
      await _notificationsPlugin.zonedSchedule(
        task.hashCode, // Unique ID for each notification
        'Reminder: ${task.title}',
        task.description,
        scheduleTime,
        details,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } else {
      _scheduleRecurringNotification(task, details, scheduleTime);
    }
  }

  Future<void> _scheduleRecurringNotification(
      Task task, NotificationDetails details, tz.TZDateTime initialTime) async {
    Duration interval;
    switch (task.recurrence) {
      case Recurrence.daily:
        interval = const Duration(days: 1);
        break;
      case Recurrence.weekly:
        interval = const Duration(days: 7);
        break;
      case Recurrence.monthly:
        interval = const Duration(days: 30); // Approximation
        break;
      default:
        return;
    }

    tz.TZDateTime nextTime = initialTime;
    while (nextTime.isBefore(DateTime.now())) {
      nextTime = nextTime.add(interval);
    }

    await _notificationsPlugin.zonedSchedule(
      task.hashCode,
      'Reminder: ${task.title}',
      task.description,
      nextTime,
      details,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: task.recurrence == Recurrence.daily
          ? DateTimeComponents.time
          : null, androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }




  void _showTaskCreator() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskCreatorScreen(
          onTaskCreated: _addTask,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks added yet!'))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(task.title),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${task.description}\nReminder: ${DateFormat.yMd().add_jm().format(task.reminderTime)}',
                  ),
                  Text(task.recurrence.name.toUpperCase())
                ],
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteTask(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskCreator,
        child: const Icon(Icons.add),
      ),
    );
  }
}