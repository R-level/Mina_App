import 'dart:io' as io;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:mina_app/model/user.dart';
import 'package:mina_app/model/cycle.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
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
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        age INTEGER,
        cycleLength INTEGER,
        periodLength INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE cycle(
        cycleId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        startDate Date,
        endDate Date,
        periodId INTEGER,
        FOREIGN KEY (userId) REFERENCES user(userId)
      )
    ''');
    
    await db.execute('''
  CREATE TABLE period(
    periodId INTEGER PRIMARY KEY AUTOINCREMENT,
    cycleId INTEGER,
    startDate Date,
    endDate Date,
    FOREIGN KEY (cycleId) REFERENCES cycle(cycleId)
  )

''');

//Alter cycles table to add period ID column
await db.execute('''
  ALTER TABLE cycle
  ADD FOREIGN KEY (periodId) REFERENCES period(periodId)
''');

await db.execute('''CREATE TABLE day(
    Date DATE PRIMARY KEY,
    CycleId INTEGER,
    isPeriodDay BOOLEAN,
    isPeriodStart BOOLEAN,
    isPeriodEnd BOOLEAN,
    NoteId INTEGER,
    FOREIGN KEY (CycleId) REFERENCES Cycle(CycleId),
    FOREIGN KEY (PeriodId) REFERENCES Period(PeriodId)
)''');

await db.execute('''CREATE TABLE Note (
    NoteId INTEGER PRIMARY KEY AUTOINCREMENT,
    Date DATE,
    Text TEXT,
    FOREIGN KEY (Date) REFERENCES Day(Date)'''
);

await db.execute('''ALTER TABLE Day
    ADD FOREIGN KEY (NoteId) REFERENCES Note (NoteId)''');

//Alter day table to add foreign key for note ID column

await db.execute('''CREATE TABLE Mood (
    MoodId INTEGER PRIMARY KEY AUTOINCREMENT,
    Date DATE,
    Name TEXT,
    FOREIGN KEY (Date) REFERENCES Day(Date)'''
);

await db.execute('''CREATE TABLE Symptom (
    SymptomId INTEGER PRIMARY KEY AUTOINCREMENT,
    Date TEXT,
    Name TEXT,
    Severity INTEGER,
    FOREIGN KEY (Date) REFERENCES Day(Date)''');
  } 

  
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

  Future<User?> getUser(String userId) async {
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

Future<void> insertCycle(Cycle cycle) async {
  final db = await database;
  await db.insert(
    'cycle',
    cycle.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

}
Future<Cycle?> getCycle(String cycleId) async {
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
}