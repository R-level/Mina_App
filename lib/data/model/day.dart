import 'package:mina_app/data/model/cycle.dart';
import 'package:mina_app/data/model/period_day.dart';
import 'package:mina_app/data/model/mood_list.dart';
import 'package:mina_app/data/model/symptom_list.dart';
import 'package:mina_app/data/model/user.dart';

class Day {
  DateTime date;

  bool isPeriodDay;
  String? note;
  SymptomList? symptomList;
  MoodList? moodList;

  Day(
      {required this.date,
      required this.isPeriodDay,
      this.note,
      this.symptomList,
      this.moodList});

  Map<String, dynamic> toMap() {
    String dateString = date.toIso8601String();
    int isPeriodDayInt = isPeriodDay ? 1 : 0;

    return {
      'date': dateString,
      'isPeriodDay': isPeriodDayInt,
      'note': note,
      'symptomList': symptomList?.toString(),
      'moodList': moodList?.toString(),
    };
  }

  factory Day.fromMap(Map<String, dynamic> map) {
    bool intToBool(int value) => value == 1;
    return Day(
      date: DateTime.parse(map['date']),
      isPeriodDay: intToBool(map['isPeriodDay']),
      note: map['note'],
      symptomList: SymptomList.fromString(map['symptomList']),
      moodList: MoodList.fromString(
        map['moodList'],
      ),
    );
  }

  int boolToInt(bool value) => value ? 1 : 0;
}
