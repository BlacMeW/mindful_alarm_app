import 'package:flutter_bloc/flutter_bloc.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';
import '../services/alarm_service.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  AlarmBloc() : super(AlarmState()) {
    on<SetAlarmEvent>(_onSetAlarm);
    on<CancelAlarmEvent>(_onCancelAlarm);
  }

  Future<void> _onSetAlarm(
    SetAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    await scheduleAlarm(event.time);
    emit(AlarmState(alarmTime: event.time));
  }

  Future<void> _onCancelAlarm(
    CancelAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    await cancelAlarm();
    emit(const AlarmState());
  }
}
