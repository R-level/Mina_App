import 'dart:io' as io;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:mina_app/data/model/model.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

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
    databaseFactory = databaseFactoryFfi;
    final io.Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = p.join(appDocDir.path, 'mina_database.db');
    if(kDebugMode) print('Database path: $path');
    return await openDatabase(
      path,
      version:1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        name STRING,
        email STRING,
        age INTEGER,
        cycleLength INTEGER,
        periodLength INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE cycle(
        cycleId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        startDate STRING,
        endDate STRING,
        periodId INTEGER,
        FOREIGN KEY (userId) REFERENCES user(userId),
        FOREIGN KEY (periodId) REFERENCES period(periodId)
      )
    ''');
    
    await db.execute('''
  CREATE TABLE period(
    periodId INTEGER PRIMARY KEY AUTOINCREMENT,
    cycleId INTEGER,
    startDate STRING,
    endDate STRING,
    FOREIGN KEY (cycleId) REFERENCES cycle(cycleId)
  )

''');



await db.execute('''CREATE TABLE Day(
    Date STRING PRIMARY KEY,
    CycleId INTEGER,
    isPeriodDay INTEGER,
    isPeriodStart INTEGER,
    isPeriodEnd INTEGER,
    NoteId INTEGER,
    PeriodId INTEGER,
    FOREIGN KEY (NoteId) REFERENCES Note (NoteId),
    FOREIGN KEY (CycleId) REFERENCES Cycle(CycleId),
    FOREIGN KEY (PeriodId) REFERENCES Period(PeriodId)
    )
    ''');

await db.execute('''CREATE TABLE Note (
    NoteId INTEGER PRIMARY KEY AUTOINCREMENT,
    Date STRING,
    Text STRING,
    FOREIGN KEY (Date) REFERENCES Day(Date)
    )'''
);



await db.execute('''CREATE TABLE Mood (
    MoodId INTEGER PRIMARY KEY AUTOINCREMENT,
    Date DATE,
    Name STRING,
    FOREIGN KEY (Date) REFERENCES Day(Date)
    )'''
);

await db.execute('''CREATE TABLE Symptom (
    SymptomId INTEGER PRIMARY KEY AUTOINCREMENT,
    Date STRING,
    Name STRING,
    Severity INTEGER,
    FOREIGN KEY (Date) REFERENCES Day(Date)
    )'''
);
  } 

//##CRUD operations for User
  
  Future<void> insertUser(User user) async {
    final db = await database;
    Map<String, dynamic> userMap = user.toMap();
    userMap.remove('userId');
    await db.insert(
      'user',
      userMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<User>> getUserList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<User?> getUser(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

//###CRUD operations for Cycle
Future<void> insertCycle(Cycle cycle) async {
  final db = await database;
  await db.insert(
    'cycle',
    cycle.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

}
Future<Cycle?> getCycle(int cycleId) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'cycle',
    where: 'cycleId = ?',
    whereArgs: [cycleId],
  );

  if (maps.isNotEmpty) {
    return Cycle.fromMap(maps.first);
  } else {
    return null;
  }
}

Future<void>updateCycle(Cycle cycle) async {
  final db = await database;
  await db.update(
    'cycle',
    cycle.toMap(),
    where: 'cycleId = ?',
    whereArgs: [cycle.cycleId],
  );
}

Future<void> deleteCycle(int cycleId) async {
  final db = await database;
  await db.delete(
    'cycle',
    where: 'cycleId = ?',
    whereArgs: [cycleId],
  );
}

//##CRUD opereations for Period

Future<void> insertPeriod(Period period) async {
  final db = await database;
  await db.insert(
    'period',
    period.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Period?> getPeriod(int periodId,int cycleId) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'period',
    where: 'periodId = ? AND cycleId = ?',
    whereArgs: [periodId,cycleId],
  );

  if (maps.isNotEmpty) {
    return Period.fromMap(maps.first);
  } else {
    return null;
  }
}

Future<void> updatePeriod(Period period) async {
  final db = await database;
  await db.update(
    'period',
    period.toMap(),
    where: 'periodId = ?',
    whereArgs: [period.periodId],
  );
}

Future<void> deletePeriod(int periodId) async {
  final db = await database;
  await db.delete(
    'period',
    where: 'periodId = ?',
    whereArgs: [periodId],
  );  
}

Future<void> insertDayEntry(Day day) async {
  final db = await database;
  await db.insert(
    'Day',
    day.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
Future<Day?> getDayEntry(DateTime date) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'Day',
    where: 'Date = ?',
    whereArgs: [date],
  );

  if (maps.isNotEmpty) {
    return Day.fromMap(maps.first);
  } else {
    return null;
  } 
  }
}