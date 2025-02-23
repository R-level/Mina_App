
class Period {

final int periodId;
final int cycleId;
final DateTime startDate;
final DateTime? endDate;
   Period({required this.periodId,required this.cycleId, required this.startDate, this.endDate});

Map<String, dynamic> toMap() {
    return {
      'periodId': periodId,
      'cycleId': cycleId,
      'startDate': startDate,
      'endDate': endDate,
    };

}

factory Period.fromMap(Map<String, dynamic> map) {
    return Period(
      periodId: map['periodId'],
      cycleId: map['cycleId'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }

  get getPeriodId => periodId;

}