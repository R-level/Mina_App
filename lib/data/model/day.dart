 import 'package:mina_app/data/model/cycle.dart';
import 'package:mina_app/data/model/period.dart';
import 'package:mina_app/data/model/mood_list.dart';
import 'package:mina_app/data/model/symptom_list.dart';

 class Day {


    int cycleId;
    bool isPeriodDay;
    bool isPeriodStart;
    bool isPeriodEnd;
    int noteId;
    Cycle? cycle;
    Period? period;
    SymptomList? symptomList;
    MoodList? moodList;
    DateTime date;
    
    
    Day({required this.date, required this.cycleId, required this.isPeriodDay, required this.isPeriodStart, required this.isPeriodEnd, required this.noteId, this.cycle, this.period, this.symptomList, this.moodList});    
    Map<String, dynamic> toMap() {
      String dateString = date.toIso8601String();
      int isPeriodDayInt = boolToInt(isPeriodDay);
      int isPeriodStartInt = boolToInt(isPeriodStart);
      int isPeriodEndInt = boolToInt(isPeriodEnd);

      return {
        'date': dateString,
        'cycleId': cycleId,
        'isPeriodDay': isPeriodDayInt,
        'isPeriodStart': isPeriodStartInt,
        'isPeriodEnd': isPeriodEndInt,
        'noteId': noteId,
        //'symptomList': ()=>symptomList.toString(),
        //'moodList': ()=>moodList.toString(),
        
      };
    }

    factory Day.fromMap(Map<String, dynamic> map) {
      bool intToBool(int value) => value == 1;
      return Day(
        date: DateTime.parse(map['date']),
        cycleId: map['cycleId'],
        isPeriodDay: intToBool(map['isPeriodDay']) ,
        isPeriodStart: intToBool(map['isPeriodStart']),
        isPeriodEnd: intToBool(map['isPeriodEnd']),
        noteId: map['noteId'],
       // cycle: map['cycle'],
       // period: map['period'],
        //symptomList: map['symptomList'],
        //moodList: map['moodList'],
        
      );
    }

    int boolToInt(bool value) => value ? 1 : 0;

    
 }