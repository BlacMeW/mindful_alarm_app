part of 'alarm_bloc.dart';

abstract class AlarmState extends Equatable {
  const AlarmState();

  @override
  List<Object?> get props => [];
}

class AlarmInitial extends AlarmState {}

class AlarmSetSuccess extends AlarmState {
  final DateTime dateTime;
  const AlarmSetSuccess(this.dateTime);

  @override
  List<Object?> get props => [dateTime];
}
