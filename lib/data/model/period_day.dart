import 'package:mina_app/data/database/databaseHelper.dart';

import 'day.dart';
import 'symptom_list.dart';
import 'mood_list.dart';

enum FlowWeight { none, light, medium, heavy }

class PeriodDay extends Day {
  FlowWeight flowWeight;
  bool isPeriodStartDay;
  bool isPeriodEndDay;

  PeriodDay({
    required DateTime date,
    required this.flowWeight,
    required this.isPeriodStartDay,
    required this.isPeriodEndDay,
    String? note,
    SymptomList? listSymptoms,
    MoodList? listMoods,
  }) : super(
          date: date,
          isPeriodDay: true,
          note: note,
          symptomList: listSymptoms,
          moodList: listMoods,
        );

  Map<String, dynamic> toPeriodDayMap() {
    return {
      'flowWeight': flowWeight.index,
      'isPeriodStartDay': isPeriodStartDay ? 1 : 0,
      'isPeriodEndDay': isPeriodEndDay ? 1 : 0,
    };
  }

  static PeriodDay fromMap(Map<String, dynamic> map) {
    bool intToBool(int value) => value == 1;
    return PeriodDay(
        date: DateTime.parse(map['Date']),
        flowWeight: map['FlowWeight'] == null
            ? FlowWeight.values[0]
            : FlowWeight.values[map[
                'FlowWeight']], //convert database value [0,1,2,3] to enum FlowWeight
        isPeriodStartDay: map['IsPeriodStartDay'] == null
            ? false
            : intToBool(map['IsPeriodStartDay']),
        isPeriodEndDay: map['IsPeriodEndDay'] == null
            ? false
            : intToBool(map['IsPeriodEndDay']),
        note: map['Note'],
        listSymptoms: SymptomList.fromString(map['symptomList']),
        listMoods: MoodList.fromString(map['moodlist']));
  }

  static List<FlowWeight> get flowWeightValues => FlowWeight.values;
}
