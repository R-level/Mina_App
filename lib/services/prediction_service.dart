import 'package:mina_app/data/model/cycle.dart';
import 'package:mina_app/data/repositories/cycle_repository.dart';

class PredictionService {
  final CycleRepository _cycleRepository;

  PredictionService({CycleRepository? cycleRepository})
      : _cycleRepository = cycleRepository ?? CycleRepository();

  Future<DateTime?> predictNextPeriod() async {
    try {
      final cycles = await _cycleRepository.calculateCycleHistory();
      if (cycles.isEmpty) return null;

      // Calculate average cycle length from the last 6 cycles or all available cycles
      final cyclesForAverage =
          cycles.length > 6 ? cycles.sublist(0, 6) : cycles;
      int totalDays = 0;

      for (int i = 0; i < cyclesForAverage.length - 1; i++) {
        final cycle = cyclesForAverage[i];
        final nextCycle = cyclesForAverage[i + 1];
        final difference =
            nextCycle.startDate.difference(cycle.startDate).inDays;
        totalDays += difference;
      }

      if (cyclesForAverage.length <= 1) return null;

      final averageCycleLength = totalDays ~/ (cyclesForAverage.length - 1);
      final lastCycle = cycles.first; // Most recent cycle

      // Predict next period start date
      return lastCycle.startDate.add(Duration(days: averageCycleLength));
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getPredictionStats() async {
    try {
      final cycles = await _cycleRepository.calculateCycleHistory();
      if (cycles.isEmpty) {
        return {
          'averageCycleLength': 0,
          'averagePeriodLength': 0,
          'cycleRegularity': 0.0,
        };
      }

      // Calculate averages from the last 6 cycles or all available cycles
      final cyclesForStats = cycles.length > 6 ? cycles.sublist(0, 6) : cycles;

      // Calculate average cycle length
      int totalCycleDays = 0;
      List<int> cycleLengths = [];
      for (int i = 0; i < cyclesForStats.length - 1; i++) {
        final difference = cyclesForStats[i + 1]
            .startDate
            .difference(cyclesForStats[i].startDate)
            .inDays;
        totalCycleDays += difference;
        cycleLengths.add(difference);
      }

      // Calculate average period length
      final totalPeriodDays =
          cyclesForStats.fold(0, (sum, cycle) => sum + cycle.periodLength);

      // Calculate cycle regularity (as a percentage based on variance)
      double regularity = 100.0;
      if (cycleLengths.length > 1) {
        final avgCycleLength = totalCycleDays / (cyclesForStats.length - 1);
        double variance = 0;
        for (final length in cycleLengths) {
          variance += (length - avgCycleLength) * (length - avgCycleLength);
        }
        variance /= cycleLengths.length;
        // Convert variance to regularity percentage (higher variance = lower regularity)
        regularity = 100 - (variance / avgCycleLength * 10).clamp(0, 100);
      }

      return {
        'averageCycleLength': cyclesForStats.length > 1
            ? totalCycleDays ~/ (cyclesForStats.length - 1)
            : 0,
        'averagePeriodLength': cyclesForStats.isNotEmpty
            ? totalPeriodDays ~/ cyclesForStats.length
            : 0,
        'cycleRegularity': regularity,
      };
    } catch (e) {
      return {
        'averageCycleLength': 0,
        'averagePeriodLength': 0,
        'cycleRegularity': 0.0,
      };
    }
  }
}
