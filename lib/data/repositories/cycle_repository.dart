import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/data/model/cycle.dart';
import 'package:mina_app/data/model/period_day.dart';

class CycleRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Cycle>> calculateCycleHistory() async {
    try {
      List<Cycle> cycles = [];
      final days = await _dbHelper.getCombinedDayAndPeriodDayRecords();

      // Sort days by date to ensure proper order
      days.sort((a, b) => a.date.compareTo(b.date));

      DateTime? currentStartDate;
      int? currentPeriodLength;

      for (int i = 0; i < days.length; i++) {
        final day = days[i];
        if (day is PeriodDay) {
          // If we find a start day, mark it
          if (day.isPeriodStartDay) {
            // If we had a previous cycle, we can now calculate its end date
            if (currentStartDate != null) {
              cycles.add(Cycle(
                startDate: currentStartDate,
                endDate: day.date.subtract(const Duration(
                    days: 1)), // End date is day before next start
                periodLength: currentPeriodLength ?? 0,
              ));
            }
            currentStartDate = day.date;
            currentPeriodLength = 0;
          }

          // Count period length until we find an end day
          if (currentStartDate != null) {
            currentPeriodLength = (currentPeriodLength ?? 0) + 1;
          }
        }
      }

      // Handle the last cycle if we have one
      if (currentStartDate != null) {
        // For the last cycle, end date is today if we don't have a next start date
        final endDate = DateTime.now();
        cycles.add(Cycle(
          startDate: currentStartDate,
          endDate: endDate,
          periodLength: currentPeriodLength ?? 0,
        ));
      }

      return cycles;
    } catch (e) {
      debugPrint('Error calculating cycle history: $e');
      return [];
    }
  }

  Future<int> calculateAvgCycleLength() async {
    try {
      final cycles = await calculateCycleHistory();
      if (cycles.isEmpty || cycles.length < 2) return 0;

      int totalLength = 0;
      for (int i = 0; i < cycles.length - 1; i++) {
        totalLength +=
            cycles[i + 1].startDate.difference(cycles[i].startDate).inDays;
      }

      return totalLength ~/ (cycles.length - 1);
    } catch (e) {
      debugPrint('Error calculating average cycle length: $e');
      return 0;
    }
  }

  Future<int> calculateAvgPeriodLength() async {
    try {
      final cycles = await calculateCycleHistory();
      if (cycles.isEmpty) return 0;

      int totalLength = 0;
      int validCycles = 0;

      for (var cycle in cycles) {
        if (cycle.periodLength > 0) {
          totalLength += cycle.periodLength;
          validCycles++;
        }
      }

      return validCycles > 0 ? totalLength ~/ validCycles : 0;
    } catch (e) {
      debugPrint('Error calculating average period length: $e');
      return 0;
    }
  }

  Future<DateTime?> predictNextPeriod() async {
    try {
      final cycles = await calculateCycleHistory();
      if (cycles.isEmpty) return null;

      final avgCycleLength = await calculateAvgCycleLength();
      if (avgCycleLength == 0) return null;

      final lastPeriod = cycles.last;
      return lastPeriod.startDate.add(Duration(days: avgCycleLength));
    } catch (e) {
      debugPrint('Error predicting next period: $e');
      return null;
    }
  }
}
