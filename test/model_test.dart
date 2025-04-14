import'package:flutter_test/flutter_test.dart';
import'package:mina_app/data/model/day.dart'; 
class ModelTest {

  ModelTest(){
    group('Day Model', () {
  test('should create a Day object with correct properties', (){
    final day = Day(
        date: DateTime(2025, 4, 4),
        cycleId: 1,
        isPeriodDay: true,
        isPeriodStart: false,
        isPeriodEnd: true,
        noteId: 42,
      );

      expect(day.date, DateTime(2025, 4, 4));
      expect(day.cycleId, 1);
      expect(day.isPeriodDay, true);
      expect(day.isPeriodStart, false);
      expect(day.isPeriodEnd, true);
      expect(day.noteId, 42);
    });

    
  });
  }
}