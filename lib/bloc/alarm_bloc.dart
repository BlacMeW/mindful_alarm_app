import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../services/alarm_service.dart';

part 'alarm_event.dart';
part 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  AlarmBloc() : super(AlarmInitial()) {
    on<SetAlarmEvent>(_onSetAlarm);
  }

  Future<void> _onSetAlarm(
    SetAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    final alarmId = 1;
    await AndroidAlarmManager.oneShotAt(
      event.dateTime,
      alarmId,
      AlarmService.triggerAlarm,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
    emit(AlarmSetSuccess(event.dateTime));
  }
}
