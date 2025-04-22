import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/data/model/day.dart';
import 'package:mina_app/data/model/period_day.dart';

class BackupService {
  final DatabaseHelper _dbHelper;

  BackupService({
    DatabaseHelper? dbHelper,
  }) : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<void> backupToLocal() async {
    try {
      // Get all data
      final days = await _dbHelper.getCombinedDayAndPeriodDayRecords();
      final settings = await _dbHelper.getAllSettings();

      // Convert data to JSON
      final backupData = {
        'days': days
            .map((day) => day is PeriodDay
                ? {'type': 'period', ...day.toMap(), ...day.toPeriodDayMap()}
                : {'type': 'day', ...day.toMap()})
            .toList(),
        'settings': settings,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Get local backup directory
      final dir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${dir.path}/backups');
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // Save backup file
      final file = File(
          '${backupDir.path}/backup_${DateTime.now().toIso8601String()}.json');
      await file.writeAsString(jsonEncode(backupData));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getLocalBackups() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${dir.path}/backups');

      if (!await backupDir.exists()) {
        return [];
      }

      final files = await backupDir
          .list()
          .where((entity) => entity.path.endsWith('.json'))
          .map((entity) => entity.path)
          .toList();

      return files;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> restoreFromLocal(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Backup file not found');
      }

      final backupData = jsonDecode(await file.readAsString());
      await _restoreFromBackup(backupData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _restoreFromBackup(Map<String, dynamic> backupData) async {
    // Clear existing data
    await _dbHelper.clearAllData();

    // Restore settings
    final settings = Map<String, String>.from(backupData['settings']);
    for (final entry in settings.entries) {
      await _dbHelper.insertOrUpdateUserSetting(entry.key, entry.value);
    }

    // Restore days
    final days = List<Map<String, dynamic>>.from(backupData['days']);
    for (final dayData in days) {
      if (dayData['type'] == 'period') {
        await _dbHelper.insertPeriodDay(PeriodDay.fromMap(dayData));
      } else {
        await _dbHelper.insertDay(Day.fromMap(dayData));
      }
    }
  }
}
