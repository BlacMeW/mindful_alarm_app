import 'package:flutter_bloc/flutter_bloc.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';
import '../alarm_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  AlarmBloc() : super(AlarmState()) {
    on<SetAlarmEvent>(_onSetAlarm);
    on<CancelAlarmEvent>(_onCancelAlarm);
    _loadSavedAlarm();
  }

  Future<void> _onSetAlarm(
    SetAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    await AndroidAlarmManager.oneShotAt(
      event.alarmTime,
      0,
      alarmCallback,
      exact: true,
      wakeup: true,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alarmTime', event.alarmTime.toIso8601String());

    emit(state.copyWith(alarmTime: event.alarmTime));
  }

  Future<void> _onCancelAlarm(
    CancelAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    await AndroidAlarmManager.cancel(0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('alarmTime');

    emit(state.copyWith(alarmTime: null));
  }

  Future<void> _loadSavedAlarm() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmStr = prefs.getString('alarmTime');
    if (alarmStr != null) {
      final parsedTime = DateTime.tryParse(alarmStr);
      if (parsedTime != null && parsedTime.isAfter(DateTime.now())) {
        add(SetAlarmEvent(parsedTime)); // re-set alarm if still in future
      }
    }
  }
}
