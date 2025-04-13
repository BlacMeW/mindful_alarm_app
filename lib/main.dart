import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'bloc/alarm_bloc.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  runApp(const MindfulAlarmApp());
}

class MindfulAlarmApp extends StatelessWidget {
  const MindfulAlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlarmBloc(),
      child: MaterialApp(
        title: 'Mindful Alarm',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: const HomeScreen(),
      ),
    );
  }
}
