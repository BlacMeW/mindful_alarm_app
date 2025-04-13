import 'package:equatable/equatable.dart';

class AlarmState extends Equatable {
  final DateTime? alarmTime;

  const AlarmState({this.alarmTime});

  @override
  List<Object?> get props => [alarmTime];
}
