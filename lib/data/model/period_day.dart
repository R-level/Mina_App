import 'day.dart';
import 'symptom_list.dart';
import 'mood_list.dart';

class PeriodDay extends Day {
  int? flowWeight;
  bool isPeriodStartDay;
  bool isPeriodEndDay;

  PeriodDay({
    required DateTime date,
    required int userId,
    this.flowWeight,
    required this.isPeriodStartDay,
    required this.isPeriodEndDay,
    String? note,
    SymptomList? listSymptoms,
    MoodList? listMoods,
  }) : super(
          userId: userId,
          date: date,
          isPeriodDay: true,
          note: note,
          symptomList: listSymptoms,
          moodList: listMoods,
        );

  Map<String, dynamic> toPeriodDayMap() {
    return {
      'flowWeight': flowWeight,
      'isPeriodStartDay': isPeriodStartDay ? 1 : 0,
      'isPeriodEndDay': isPeriodEndDay ? 1 : 0,
    };
  }

  static PeriodDay fromMap(Map<String, dynamic> map) {
    bool intToBool(int value) => value == 1;
    return PeriodDay(
        date: DateTime.parse(map['Date']),
        userId: map['userId'],
        flowWeight: map['FlowWeight'],
        isPeriodStartDay: intToBool(map['IsPeriodStartDay']),
        isPeriodEndDay: intToBool(map['IsPeriodEndDay']),
        note: map['Note'],
        listSymptoms: SymptomList.fromString(map['ListSymptoms']),
        listMoods: MoodList.fromString(map['ListMoods']));
  }
}
