import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/data/model/model.dart';

class DayEntryRepository {
  DayEntryRepository._privateConstructor();
  static final DayEntryRepository _instance =
      DayEntryRepository._privateConstructor();
  static DayEntryRepository get instance => _instance;

  Future<void> insertDayEntry(Day day) async {
    try {
      await DatabaseHelper().insertDay(day);
    } catch (e) {
      // Log the error and rethrow a custom exception
      print('Error inserting Day entry: $e');
      throw Exception('Failed to insert Day entry');
    }
  }

  Future<Day?> getDayEntry(DateTime date) async {
    return await DatabaseHelper().getDay(date);
    /* } catch (e) {
      // Log the error and rethrow a custom exception
      print('Error retrieving Day entry: $e');
      throw Exception('Failed to retrieve Day entry');
    } */
  }

  Future<List<Day>> getAllDaysandPeriodDays() async {
    try {
      final result = await DatabaseHelper().getCombinedDayAndPeriodDayRecords();
      return result;
    } catch (e) {
      // Log the error and rethrow a custom exception
      print('Error retrieving all Days and PeriodDays: $e');
      throw Exception('Failed to retrieve all Days and PeriodDays');
    }
  }
}
