import 'package:equatable/equatable.dart';

//A class to represent a menstrual cycle
//A menstrual cycle will have a start date, an end date, and a period length
//A start date is the first day of the menstrual cycle = PeriodDay.isStartDay=true.
//An end date is the last day of the menstrual cycle which is the day before the next a new Cycle's startDay.
//End date is calculated when a new PeriodDay.isStartDay = true is found upon the CycleRepository.calculateCycleHistory method is called.
//A period length is the number of days between the start date and a the date of a subsequent PeriodDay.isLastPeriodDay = true.
class Cycle extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final int periodLength;

  const Cycle({
    required this.startDate,
    required this.endDate,
    required this.periodLength,
  });

  @override
  List<Object?> get props => [startDate, endDate, periodLength];

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'periodLength': periodLength,
    };
  }

  factory Cycle.fromMap(Map<String, dynamic> map) {
    return Cycle(
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      periodLength: map['periodLength'],
    );
  }
}
