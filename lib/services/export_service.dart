import 'dart:io';
import 'package:csv/csv.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mina_app/data/repositories/cycle_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportService {
  final CycleRepository _cycleRepository;

  ExportService({CycleRepository? cycleRepository})
      : _cycleRepository = cycleRepository ?? CycleRepository();

  /* Future<void> exportCycleData() async {
    try {
      // Get all cycle data
      final cycles = await _cycleRepository.calculateCycleHistory();
      final days = await DatabaseHelper().getCombinedDayAndPeriodDayRecords();

      // Prepare CSV data
      List<List<dynamic>> cycleRows = [
        [
          'Start Date',
          'End Date',
          'Period Length',
          'Cycle Length',
          'Symptoms',
          'Moods',
          'Notes'
        ]
      ];

      for (final cycle in cycles) {
        final daysInCycle = days.where((day) =>
            day.date
                .isAfter(cycle.startDate.subtract(const Duration(days: 1))) &&
            day.date.isBefore(cycle.endDate.add(const Duration(days: 1))));

        final symptoms = daysInCycle
            .where((d) => d.symptomList != null)
            .map((d) => d.symptomList!.symptoms)
            .expand((i) => i)
            .toSet()
            .join(', ');

        final moods = daysInCycle
            .where((d) => d.moodList != null)
            .map((d) => d.moodList!.moods)
            .expand((i) => i)
            .toSet()
            .join(', ');

        final notes = daysInCycle
            .where((d) => d.note != null && d.note!.isNotEmpty)
            .map((d) => d.note)
            .join(' | ');

        cycleRows.add([
          cycle.startDate.toIso8601String(),
          cycle.endDate.toIso8601String(),
          cycle.periodLength,
          cycle.endDate.difference(cycle.startDate).inDays,
          symptoms,
          moods,
          notes,
        ]); 
      }

      // Convert to CSV
      String csv = const ListToCsvConverter().convert(cycleRows);

      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/cycle_data.csv');
      await file.writeAsString(csv);

      // Share the file
      await Share.shareXFiles([XFile(file.path)], subject: 'Cycle Data Export');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> exportPdfReport() async {
    // TODO: Implement PDF export with detailed visualizations
  }*/
}
