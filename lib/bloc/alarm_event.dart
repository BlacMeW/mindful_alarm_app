abstract class AlarmEvent {}

class SetAlarmEvent extends AlarmEvent {
  final DateTime alarmTime;

  SetAlarmEvent(this.alarmTime);
}

class CancelAlarmEvent extends AlarmEvent {}
