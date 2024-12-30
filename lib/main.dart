import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:memento/task_manager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


final FlutterLocalNotificationsPlugin _notificationsPlugin =
FlutterLocalNotificationsPlugin();


// Callback to handle notification actions
Future<void> onNotificationAction(NotificationResponse response) async {
  final payload = response.payload;

  if (response.actionId == 'mark_done') {
    if (kDebugMode) {
      print('Task marked as done: $payload');
    }

  } else if (response.actionId == 'snooze') {
    if (kDebugMode) {
      print('Task snoozed: $payload');
    }
    await snoozeTask(payload!);
  }
}



Future<void> snoozeTask(String taskTitle) async {
  final DateTime snoozeTime = DateTime.now().add(const Duration(minutes: 10));

  await _notificationsPlugin.zonedSchedule(
    1, // New notification ID for snooze
    'Snooze: $taskTitle',
    'Reminder after 10 minutes.',
    tz.TZDateTime.from(snoozeTime, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'task_reminders',
        'Task Reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),

    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones(); // Initialize timezone data

  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

   DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(

    notificationCategories: <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        'task_reminder',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('mark_done', 'Mark as Done'),
          DarwinNotificationAction.plain('snooze', 'Snooze'),
        ],
      ),
    ],
  );

   InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iOSSettings,
  );

  await _notificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: onNotificationAction,
  );

  runApp(const TaskApp());

}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // Automatically adapt to system theme
      home: const TaskManagerScreen(),
    );
  }
}




