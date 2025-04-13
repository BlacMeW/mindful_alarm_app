import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/alarm_bloc.dart';

class TimePickerButton extends StatelessWidget {
  const TimePickerButton({super.key});

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timeOfDay != null) {
      final now = DateTime.now();
      final alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      if (alarmTime.isBefore(now)) {
        // If picked time already passed today, set for tomorrow
        final adjustedAlarmTime = alarmTime.add(const Duration(days: 1));
        context.read<AlarmBloc>().add(SetAlarmEvent(adjustedAlarmTime));
      } else {
        context.read<AlarmBloc>().add(SetAlarmEvent(alarmTime));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.access_time),
      label: const Text("Pick Alarm Time"),
      onPressed: () => _pickTime(context),
    );
  }
}
