import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindful_alarm_app/widgets/time_picker_button.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bloc/alarm_bloc.dart';
import '../utils/ringtone_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pickTime(BuildContext context) async {
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timeOfDay != null) {
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
      context.read<AlarmBloc>().add(SetAlarmEvent(dateTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mindful Alarm')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<AlarmBloc, AlarmState>(
              builder: (context, state) {
                if (state is AlarmSetSuccess) {
                  return Text('Alarm set for: ${state.dateTime}');
                }
                return const Text('No alarm set');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickTime(context),
              child: const Text('Set Alarm'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => RingtoneUtils.playRingtone(),
              child: const Text('Test Ringtone'),
            ),
            const SizedBox(height: 10),
            TimePickerButton(),
          ],
        ),
      ),
    );
  }
}
