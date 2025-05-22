import 'package:equatable/equatable.dart';

abstract class PeriodDayPickerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PeriodDaysFetched extends PeriodDayPickerEvent {}

class PeriodDayToggled extends PeriodDayPickerEvent {
  final DateTime day;
  PeriodDayToggled(this.day);

  @override
  List<Object> get props => [day];
}
