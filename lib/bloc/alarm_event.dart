part of 'alarm_bloc.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();
}

class SetAlarmEvent extends AlarmEvent {
  final DateTime dateTime;
  const SetAlarmEvent(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}
