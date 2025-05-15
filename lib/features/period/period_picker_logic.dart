import 'package:sqflite/sqflite.dart';
import 'package:mina_app/data/model/cycle.dart';
import 'package:mina_app/data/database/databaseHelper.dart';

class PeriodPicker {
  PeriodPicker();
  void saveEditedDays(Set<DateTime> selectedDates) {
    if (selectedDates.isEmpty) return;

    //  Sort the selected dates
    final sortedDates = selectedDates.toList()..sort();

    saveCycles(sortedDates);
    savePeriodDays(sortedDates);
  }

  Future<void> saveCycles(List<DateTime> sortedDates) async {
    final Database db = await DatabaseHelper().database;
    //  Group dates into contiguous ranges
    final List<List<DateTime>> cycles = [];
    List<DateTime> currentCycle = [sortedDates.first];

    for (int i = 1; i < sortedDates.length; i++) {
      if (sortedDates[i].difference(sortedDates[i - 1]).inDays == 1) {
        currentCycle.add(sortedDates[i]);
      } else {
        cycles.add(currentCycle);
        currentCycle = [sortedDates[i]];
      }
    }
    cycles.add(currentCycle);

    // Prepare the new cycle records
    final List<Cycle> newCycleRecords = [];
    for (int i = 0; i < cycles.length; i++) {
      final startDate = cycles[i].first;
      final periodEndDate = cycles[i].last;
      final endDate = (i < cycles.length - 1)
          ? cycles[i + 1].first.subtract(Duration(days: 1))
          : null; //cycle still to be completed
//TODo create Cycle class
      newCycleRecords.add(Cycle(
          startDate: startDate,
          periodEndDate: periodEndDate,
          endDate: endDate));
    }

    // Delete existing records for the affected months
    final affectedMonths =
        sortedDates.map((date) => DateTime(date.year, date.month, 1)).toSet();
    final affectedMonthsStart =
        affectedMonths.map((month) => month.toIso8601String()).toList();
    final affectedMonthsEnd = affectedMonths
        .map((month) => DateTime(month.year, month.month + 1, 1)
            .subtract(Duration(days: 1))
            .toIso8601String())
        .toList();

    await db.transaction((txn) async {
      for (int i = 0; i < affectedMonthsStart.length; i++) {
        await txn.delete(
          'Cycle',
          where:
              '(StartDate BETWEEN ? AND ?) OR (CycleEndDate BETWEEN ? AND ?)',
          whereArgs: [
            affectedMonthsStart[i],
            affectedMonthsEnd[i],
            affectedMonthsStart[i],
            affectedMonthsEnd[i],
          ],
        );
      }

      // Insert the new cycle records
      for (final record in newCycleRecords) {
        await txn.insert('Cycle', record.toMap());
      }
    });
  }

  savePeriodDays(List<DateTime> sortedDates) {
    //ToDo implement logic to save period days in the database
    //correctly only by inserting the days affected
    //One can look at the cycles table and correctly
    //mark which days are period startDays and which are endDays
    //alternatively
    //delete all the within a range of edited days period days and insert the new ones in the database
    //Any deletions automatically marks a Day entry as not a period day (isPeriodDay = false)
    //DatabaseHelper().savePeriodDays(sortedDates);
  }
}
