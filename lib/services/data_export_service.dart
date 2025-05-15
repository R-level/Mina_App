import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mina_app/data/repositories/cycle_repository.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/data/model/period_day.dart';

class DataExportService {
  final DatabaseHelper _dbHelper;
  final CycleRepository _cycleRepository;

  DataExportService({
    DatabaseHelper? dbHelper,
    CycleRepository? cycleRepository,
  })  : _dbHelper = dbHelper ?? DatabaseHelper(),
        _cycleRepository = cycleRepository ?? CycleRepository();

  Future<String> exportToCsv() async {
    final days = await _dbHelper.getCombinedDayAndPeriodDayRecords();
    final cycles = await _cycleRepository.calculateCycleHistory();

    // Prepare data for CSV
    List<List<dynamic>> cycleRows = [
      ['Cycle Start Date', 'Cycle End Date', 'Period Length', 'Cycle Length']
    ];

/*     for (final cycle in cycles) {
      final cycleLength = cycle.endDate.difference(cycle.startDate).inDays;
      cycleRows.add([
        cycle.startDate.toIso8601String(),
        cycle.endDate.toIso8601String(),
        cycle.periodLength,
        cycleLength,
      ]);
    } */

    List<List<dynamic>> dayRows = [
      [
        'Date',
        'Is Period Day',
        'Flow Weight',
        'Is Period Start',
        'Is Period End',
        'Symptoms',
        'Moods',
        'Notes'
      ]
    ];

    for (final day in days) {
      dayRows.add([
        day.date.toIso8601String(),
        day.isPeriodDay ? 'Yes' : 'No',
        day is PeriodDay ? day.flowWeight : '',
        day is PeriodDay ? (day.isPeriodStartDay ? 'Yes' : 'No') : '',
        day is PeriodDay ? (day.isPeriodEndDay ? 'Yes' : 'No') : '',
        day.symptomList?.toString() ?? '',
        day.moodList?.toString() ?? '',
        day.note ?? '',
      ]);
    }

    // Convert to CSV
    String cyclesCsv = const ListToCsvConverter().convert(cycleRows);
    String daysCsv = const ListToCsvConverter().convert(dayRows);

    // Create export directory
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    // Write files
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final cyclesFile = File('${exportDir.path}/mina_cycles_$timestamp.csv');
    final daysFile = File('${exportDir.path}/mina_days_$timestamp.csv');

    await cyclesFile.writeAsString(cyclesCsv);
    await daysFile.writeAsString(daysCsv);

    return exportDir.path;
  }

  Future<void> shareExport() async {
    try {
      final exportPath = await exportToCsv();
      final directory = Directory(exportPath);
      final files = directory.listSync().whereType<File>().toList();

      if (files.isNotEmpty) {
        await Share.shareFiles(
          files.map((f) => f.path).toList(),
          text: 'Mina App Data Export',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
