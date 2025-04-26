import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:mina_app/data/model/model.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  //Create Singleton instance of the database
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final io.Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = p.join(appDocDir.path, 'mina_database.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Add this line
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db
          .execute('ALTER TABLE Day RENAME COLUMN ListSymptoms TO symptomList');
    }
  }

  /// This is the callback function that is called when the database is first
  /// created. It creates the following tables:
  ///
  /// - UserSettings: a table to store user settings such as the selected theme
  /// - Day: a table to store Day objects, which contain information about a
  ///   given day in the user's cycle
  /// - PeriodDay: a table to store PeriodDay objects, which contain information
  ///   about the user's period
  /// - Mood: a table to store Mood objects, which contain information about the
  ///   user's mood
  /// - Symptom: a table to store Symptom objects, which contain information
  ///   about the user's symptoms

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE UserSettings(
      Key STRING PRIMARY KEY,
      Value STRING
      )
    ''');

    await db.execute('''CREATE TABLE Day(
    Date STRING PRIMARY KEY,
    IsPeriodDay INTEGER,
    Note String,
    symptomList String,
    moodlist String
    )
    ''');

    await db.execute('''
  CREATE TABLE PeriodDay(
    Date STRING PRIMARY KEY,
    FlowWeight INTEGER,
    IsPeriodStartDay INTEGER,
    IsPeriodEndDay INTEGER,
    FOREIGN KEY (Date) REFERENCES Day(Date)
  )
''');

    await db.execute('''CREATE TABLE Mood (
    MoodId INTEGER PRIMARY KEY AUTOINCREMENT,
    Name STRING
    
    )''');

    await db.execute('''CREATE TABLE Symptom (
    SymptomId INTEGER PRIMARY KEY AUTOINCREMENT,
    Name STRING
   
    )''');
  }

//##CRUD operations for UserSettings

  /// Inserts or updates a user setting.
  ///
  /// If a setting with the given [key] does not exist, it is inserted.
  /// Otherwise, the existing setting is updated with the new [value].
  ///
  /// This method is asynchronous because it may need to wait for the database
  /// to initialize.
  Future<void> insertOrUpdateUserSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'UserSettings',
      {'Key': key, 'Value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves a setting from the database.
  ///
  /// The [key] parameter is the name of the setting to retrieve.
  ///
  /// Returns the value of the setting if it exists, or `null` if it does not.
  ///
  /// This method is asynchronous because it may need to wait for the database
  /// to initialize.

  Future<String?> getUserSetting(String key) async {
    final db = await database;

    // Query the setting
    final List<Map<String, dynamic>> result = await db.query(
      'UserSettings',
      where: 'Key = ?',
      whereArgs: [key],
    );

    if (result.isNotEmpty) {
      return result.first['Value'] as String;
    } else {
      return null; // Return null if the key does not exist
    }
  }

  /// Retrieves all settings from the database as a map.
  ///
  /// The returned map will have the setting names as keys and the
  /// corresponding setting values as values.
  ///
  /// This method is asynchronous because it may need to wait for the database
  /// to initialize.
  Future<Map<String, String>> getAllSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> settings = await db.query('UserSettings');
    return Map.fromEntries(
      settings
          .map((row) => MapEntry(row['Key'] as String, row['Value'] as String)),
    );
  }

//CRUD operations for Day table
  //CREATE DAY Record
  /// Inserts a day entry into the database.
  ///
  /// If a day entry with the same date already exists, it will be replaced.
  /// The [day] parameter contains the details of the day entry to be inserted.
  /// This operation uses [ConflictAlgorithm.replace] to handle conflicts.

  Future<void> insertDay(Day day) async {
    final db = await database;
    await db.insert(
      'Day',
      day.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //READ DAY Record
  /// Retrieves a day entry from the database.
  ///
  /// If a day entry with the given [date] does not exist, returns `null`.
  /// Otherwise, returns the day entry.
  Future<Day?> getDay(DateTime date) async {
    final db = await database;

    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT Day.Date,Day.IsPeriodDay,Day.Note,Day.symptomList,Day.moodList,
      PeriodDay.FlowWeight,PeriodDay.IsPeriodStartDay,PeriodDay.IsPeriodEndDay
      FROM Day
      LEFT JOIN PeriodDay ON Day.Date = PeriodDay.Date
      WHERE Day.Date=?
      ''', [date.toIso8601String()]);

    if (result.isNotEmpty) {
      final Map<String, dynamic> row = result.first;

      //Check if Day is a PeriodDay
      if (row['IsPeriodDay'] == 1) {
        return PeriodDay.fromMap(row);
      } else {
        return Day.fromMap(row);
      }
    } else {
      return null;
    }
  }

//UPDATE DAY Record
  Future<void> updateDay(Day day) async {
    final db = await database;

    if (!day.isPeriodDay) {
      await db.update(
        'Day',
        day.toMap(),
        where: 'Date = ?',
        whereArgs: [day.date],
      );
      //Delete Period information
      // if day is changed from a Period Day to a non-Period Day
      await db.delete('PeriodDay', where: 'Date=?', whereArgs: [day.date]);
    } else {}
  }

  //DELETE DAY Record
  Future<void> deleteDayEntry(DateTime date) async {
    final db = await database;
    await db.delete(
      'Day',
      where: 'Date = ?',
      whereArgs: [date],
    );
    //Delete corresponding PeriodDay
    await db.delete(
      'PeriodDay',
      where: 'Date = ?',
      whereArgs: [date],
    );
  }

//CRUD operations for PeriodDay
  Future<void> insertPeriodDay(PeriodDay periodDay) async {
    final db = await database;
    await db.insert(
      'Day',
      periodDay.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // Insert into PeriodDay table
    await db.insert(
      'PeriodDay',
      periodDay.toPeriodDayMap(), // Includes only PeriodDay-specific columns
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Deletes a PeriodDay entry for a given date from the database.
  ///
  /// This method removes the corresponding PeriodDay record from the 'PeriodDay'
  /// table based on the provided [date]. Additionally, it updates the 'Day' table
  /// to set the 'IsPeriodDay' flag to false, indicating that the day is no longer
  /// considered a period day.
  ///

  Future<void> deletePeriodDay(DateTime date) async {
    final db = await database;

    // Delete the PeriodDay entry
    await db.delete(
      'PeriodDay',
      where: 'Date = ?',
      whereArgs: [date],
    );

    //Update the Day table to mark it as not a period day
    await db.update(
      'Day',
      {'IsPeriodDay': 0}, // Set IsPeriodDay to false
      where: 'Date = ?',
      whereArgs: [date],
    );
  }

  Future<List<Day>> getPeriodDaysInRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'days',
      where: 'Date BETWEEN ? AND ? AND IsPeriodDay = 1',
      whereArgs: [
        start.toIso8601String(),
        end.toIso8601String(),
      ],
    );

    return List.generate(maps.length, (i) {
      return Day.fromMap(maps[i]);
    });
  }

  //READ ALL DAY Records
  Future<List<Day>> getCombinedDayAndPeriodDayRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT Day.Date,Day.IsPeriodDay,Day.Note,Day.ListSymptoms,Day.ListMoods,
      PeriodDay.FlowWeight,PeriodDay.IsPeriodStartDay,PeriodDay.IsPeriodEndDay
      FROM Day
      LEFT JOIN PeriodDay ON Day.Date = PeriodDay.Date
      ORDER BY Day.Date ASC''');

    // Map the results to a list of Day and PeriodDay objects
    return result.map<Day>((row) {
      if (row['IsPeriodDay'] == 1) {
        // If IsPeriodDay is 1, create a PeriodDay object
        return PeriodDay.fromMap(row);
      } else {
        // Otherwise, create a Day object
        return Day.fromMap(row);
      }
    }).toList();
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      // Clear all tables
      await txn.delete('Day');
      await txn.delete('PeriodDay');
      await txn.delete('UserSettings');
    });
  }

  Future<List<Day>> getAllDays() async {
    return getCombinedDayAndPeriodDayRecords();
  }
}
