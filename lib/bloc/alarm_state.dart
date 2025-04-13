class AlarmState {
  final DateTime? alarmTime;

  AlarmState({this.alarmTime});

  AlarmState copyWith({DateTime? alarmTime}) {
    return AlarmState(alarmTime: alarmTime ?? this.alarmTime);
  }
}
