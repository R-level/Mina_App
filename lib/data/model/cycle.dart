import 'package:equatable/equatable.dart';

class Cycle extends Equatable {
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime periodEndDate;

  const Cycle({
    required this.startDate,
    this.endDate,
    required this.periodEndDate,
  });

  @override
  List<Object?> get props => [startDate, endDate, periodEndDate];

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate != null ? endDate!.toIso8601String() : "",
      'periodEndDate': periodEndDate.toIso8601String(),
    };
  }

  factory Cycle.fromMap(Map<String, dynamic> map) {
    return Cycle(
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      periodEndDate: map['periodEndDate'],
    );
  }
}
