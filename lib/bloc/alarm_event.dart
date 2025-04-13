import 'package:equatable/equatable.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();
}

class SetAlarmEvent extends AlarmEvent {
  final DateTime time;
  const SetAlarmEvent(this.time);

  @override
  List<Object> get props => [time];
}

class CancelAlarmEvent extends AlarmEvent {
  const CancelAlarmEvent();

  @override
  List<Object> get props => [];
}
