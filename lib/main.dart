import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:mindful_alarm_app/bloc/alarm_event.dart';
import 'package:mindful_alarm_app/bloc/alarm_state.dart';

import 'bloc/alarm_bloc.dart';
import 'services/alarm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await initializeNotifications();

  runApp(BlocProvider(create: (_) => AlarmBloc(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindful Alarm',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const AlarmPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
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
      if (alarmTime.isBefore(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a future time')),
        );
        return;
      }
      context.read<AlarmBloc>().add(SetAlarmEvent(alarmTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mindful Alarm")),
      body: BlocBuilder<AlarmBloc, AlarmState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.alarmTime == null
                      ? "No alarm set"
                      : "Alarm: ${TimeOfDay.fromDateTime(state.alarmTime!).format(context)}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _pickTime(context),
                  child: const Text("Set Alarm"),
                ),
                if (state.alarmTime != null) ...[
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:
                        () => context.read<AlarmBloc>().add(CancelAlarmEvent()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Cancel Alarm"),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
