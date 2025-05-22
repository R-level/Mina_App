import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:mina_app/data/model/cycle.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/data/model/period_day.dart';
import 'package:mina_app/data/model/day.dart';
import 'package:flutter/foundation.dart';

class PeriodPicker {
  PeriodPicker();
  List<DateTime> deselecetedPeriodDates = [];

  //selectedDates are a list of all the dates that have been selected.
  void saveEditedDays(Set<DateTime> selectedDates, Set<DateTime> oldPeriodSet) {
    if (selectedDates.isEmpty) return;

    //  Sort the selected dates
    final sortedDates = selectedDates.toList()..sort();

    //
    deselecetedPeriodDates = oldPeriodSet.difference(selectedDates).toList()
      ..sort();
    saveCycles(sortedDates);
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
    //TODO: Make exception for initial cycle entry for new users: periodEndDate may not be reached yet.
    //...Perhaps if last day in period selection is DateTime.now() we must set periodEndDate to null
    //--
    final List<Cycle> newCycleRecords = [];
    for (int i = 0; i < cycles.length; i++) {
      final startDate = cycles[i].first;
      final periodEndDate = cycles[i].last;
      final endDate = (i < cycles.length - 1)
          ? cycles[i + 1].first.subtract(Duration(days: 1))
          : null; //cycle still to be completed

      newCycleRecords.add(Cycle(
          startDate: normalizeDate(startDate),
          periodEndDate: normalizeDate(periodEndDate),
          endDate: endDate != null ? normalizeDate(endDate) : null));
    }
//Process periodDays into database
    savePeriodDays(newCycleRecords, cycles);

    // Delete existing Cycle records for the affected months
    final affectedMonths =
        sortedDates.map((date) => DateTime(date.year, date.month, 1)).toSet();
    final affectedMonthsStart =
        affectedMonths.map((month) => month.toIso8601String()).toList();
    final affectedMonthsEnd = affectedMonths
        .map((date) => DateTime(date.year, date.month + 1, 1)
            .subtract(Duration(days: 1))
            .toIso8601String())
        .toList();

    await db.transaction((txn) async {
      for (int i = 0; i < affectedMonthsStart.length; i++) {
        await txn.delete(
          'Cycle',
          where: '(startDate BETWEEN ? AND ?) OR (endDate BETWEEN ? AND ?)',
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

  /*List<Cycle> startDate_and_endDate_CycleRecords and
      List<List<DateTime>> cycleDateTimeRangeList will always have the same size*/
  savePeriodDays(List<Cycle> startDate_and_endDate_CycleRecords,
      List<List<DateTime>> cycleDateTimeRangeList) async {
    List<List<DateTime>> cycles = cycleDateTimeRangeList;

    final db = await DatabaseHelper().database;
    await db.transaction((txn) async {
      for (int i = 0; i < cycles.length; i++) {
        Cycle curCycle = startDate_and_endDate_CycleRecords[i];
//#### Process PeriodDays ####
        for (int j = 0; j < cycles[i].length; j++) {
          // Normalize date to remove time
          DateTime curDate = normalizeDate(cycles[i][j]);

          // 1. Try to get existing PeriodDay for this date
          PeriodDay? existing =
              await DatabaseHelper().getPeriodDayByDate(curDate, txn: txn);

          //If a day is a PeriodDay and it exists in the PeriodDay table
          //it should only be updated if it is now a periodEndDay or PeriodStartDay
          //If a day exists in the database that needs to be changed from a periodStartDay/periodEndDay
          //to a normal PeriodDay we should update the entry by changing the flags as necessary

          //Process edge case where only one Period day exists
          if (curDate == curCycle.startDate &&
              curDate == curCycle.periodEndDate) {
            //if it the record does not exist
            if (existing == null) {
              PeriodDay newPeriodDay = PeriodDay(
                date: curDate,
                flowWeight: FlowWeight.none, // or your default/desired value
                isPeriodStartDay: true,
                isPeriodEndDay: true,
              );
              await DatabaseHelper().insertPeriodDay(newPeriodDay, txn: txn);
            } else {
              //record does exist, update it as a start and end day
              PeriodDay updated = existing.copyWith(
                  isPeriodStartDay: true, isPeriodEndDay: true);
              await DatabaseHelper().updatePeriodDay(updated, txn: txn);
            }
          }

          //Process Start Day Period

          if (curDate == curCycle.startDate &&
              curDate != curCycle.periodEndDate) {
            if (existing != null) {
              // 2. If it exists and is already a start day, do nothing
              if (!existing.isPeriodStartDay) {
                // 3. If not a start day, update it to be a start day, keep flowWeight
                PeriodDay updated = existing.copyWith(
                    isPeriodStartDay: true, isPeriodEndDay: false);
                await DatabaseHelper().updatePeriodDay(updated, txn: txn);
              }
            } else {
              // 4. If it does not exist, insert new PeriodDay as start day
              PeriodDay newPeriodDay = PeriodDay(
                date: curDate,
                flowWeight: FlowWeight.none, // or your default/desired value
                isPeriodStartDay: true,
                isPeriodEndDay: false,
              );
              await DatabaseHelper().insertPeriodDay(newPeriodDay, txn: txn);
            }
          }

          //Process PeriodDays

          if (curDate.isAfter(curCycle.startDate) &&
              curDate.isBefore(curCycle.periodEndDate)) {
            if (existing != null) {
              if (curDate == existing.date) {
                //Existing record is a periodDay that is not a start or end day; update flags as necessary
                PeriodDay updated = existing.copyWith(
                    isPeriodStartDay: false, isPeriodEndDay: false);
                await DatabaseHelper().updatePeriodDay(updated, txn: txn);
              }
            } //Existing record does not exist; create new record
            else {
              PeriodDay newPeriodDay = PeriodDay(
                date: curDate,
                flowWeight: FlowWeight.none, // default
                isPeriodStartDay: false,
                isPeriodEndDay: false,
              );
              await DatabaseHelper().insertPeriodDay(newPeriodDay, txn: txn);
            }
          }
          //Process periodEndDays

          if (curDate == curCycle.periodEndDate &&
              curDate != curCycle.startDate) {
            if (existing != null) {
              if (!existing.isPeriodEndDay) {
                //Existing record is not a periodEndDay

                await DatabaseHelper().updatePeriodDay(
                    existing.copyWith(
                        isPeriodEndDay: true, isPeriodStartDay: false),
                    txn: txn);
              }
              //Existing record is a periodEndDay; do nothing
            }
            //Existing record does not exist; create new record
            else {
              PeriodDay newPeriodDay = PeriodDay(
                date: curDate,
                flowWeight: FlowWeight.none, // default
                isPeriodStartDay: false,
                isPeriodEndDay: true,
              );
              await DatabaseHelper().insertPeriodDay(newPeriodDay, txn: txn);
            }

//###### Process normal Days ######

            //If a Day is not a PeriodDay anymore, it should be deleted from the PeriodDay table
            if (deselecetedPeriodDates.isNotEmpty) {
              if (deselecetedPeriodDates.contains(curDate)) {
                await DatabaseHelper().deletePeriodDay(curDate, txn: txn);
              }
            }
            //The database helper class helps on deletion of a PeriodDay entry by marking the
            //corresponding Day table isPeriodDay flag to false.
          }
        }
      }
    });
  }

  normalizeDate(DateTime startDate) {
    return DateTime(startDate.year, startDate.month, startDate.day);
  }
}
