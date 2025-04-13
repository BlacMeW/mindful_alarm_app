import 'package:flutter/foundation.dart'; // for kIsWeb
import 'dart:io' show Platform; // keep this for mobile platforms

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'bloc/alarm_bloc.dart';
import 'bloc/alarm_event.dart';
import 'bloc/alarm_state.dart';
import 'alarm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
    await initializeNotifications();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlarmBloc(),
      child: MaterialApp(
        title: 'Mindful Alarm Bloc',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: AlarmPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AlarmPage extends StatelessWidget {
  // Pick alarm time
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      if (alarmTime.isAfter(now)) {
        context.read<AlarmBloc>().add(SetAlarmEvent(alarmTime));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please choose a future time")));
      }
    }
  }

  // Cancel alarm
  void _cancelAlarm(BuildContext context) {
    context.read<AlarmBloc>().add(CancelAlarmEvent());
  }

  // Stream to show current time
  Stream<DateTime> tick() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mindful Alarm Bloc')),
      body: BlocListener<AlarmBloc, AlarmState>(
        listener: (context, state) {
          if (state.alarmTime != null) {
            final formattedTime = TimeOfDay.fromDateTime(
              state.alarmTime!,
            ).format(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Alarm set for $formattedTime")),
            );
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Alarm canceled")));
          }
        },
        child: Center(
          child: BlocBuilder<AlarmBloc, AlarmState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Current Time StreamBuilder
                  StreamBuilder<DateTime>(
                    stream: tick(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      final now = snapshot.data!;
                      final formatted = TimeOfDay.fromDateTime(
                        now,
                      ).format(context);
                      return Text(
                        "⏰ Current Time: $formatted",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  // Set alarm button
                  ElevatedButton(
                    onPressed: () => _pickTime(context),
                    child: Text("Set Mindful Alarm"),
                  ),
                  // Cancel alarm button
                  if (state.alarmTime != null)
                    ElevatedButton(
                      onPressed: () => _cancelAlarm(context),
                      child: Text("Cancel Alarm"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
