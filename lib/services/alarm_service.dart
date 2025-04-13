import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  tz.initializeTimeZones();
  const AndroidInitializationSettings initSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(android: initSettings),
  );
}

Future<void> scheduleAlarm(DateTime time) async {
  final id = 0;
  await AndroidAlarmManager.oneShotAt(
    time,
    id,
    triggerAlarm,
    exact: true,
    wakeup: true,
  );
}

void triggerAlarm() {
  _showNotification();
}

Future<void> _showNotification() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'mindful_alarm_channel',
    'Mindful Alarm',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'Mindful Alarm',
    'Time to breathe mindfully 🧘‍♀️',
    platformDetails,
  );
}

Future<void> cancelAlarm() async {
  await AndroidAlarmManager.cancel(0);
}
