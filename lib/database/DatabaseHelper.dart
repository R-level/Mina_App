import 'dart:io' as io;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:mina_app/model/user.dart';
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
      CREATE TABLE users(
        userId TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        age INTEGER,
        cycleLength INTEGER,
        periodLength INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE cycles(
        cycleId TEXT PRIMARY KEY,
        startDate:DateTime,
        endDate:DateTime,
        cycleLength INTEGER,
        FOREIGN KEY (userId) REFERENCES users(userId)
      )
    ''');
    
    await db.execute('''
  CREATE TABLE periods(
    periodId TEXT PRIMARY KEY,
    startDate:DateTime,
    endDate:DateTime,
    periodLength INTEGER,
    FOREIGN KEY (cycleId) REFERENCES cycles(cycleId)
  )

''');

//Alter cycles table to add period ID column
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }
}