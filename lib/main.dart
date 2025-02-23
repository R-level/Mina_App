import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mina_app/database/DatabaseHelper.dart';
import 'package:mina_app/screens/home.dart';
import 'package:mina_app/model/user.dart';
import 'package:flutter/foundation.dart';



void main()  async {
WidgetsFlutterBinding.ensureInitialized();
  // Initialize FFI
  sqfliteFfiInit();
  // Set the database factory
  databaseFactory = databaseFactoryFfi;

final dbHelper = DatabaseHelper();
  var user = User( userId: 0,name: 'Jane Doe', email: 'jane.doe@example.com', age: 25, cycleLength: 28, periodLength: 5);
  await dbHelper.insertUser(user);

  var storedUser = await dbHelper.getUser(0);
  
   if (kDebugMode) {
    debugPrint(storedUser?.name);
  }
   // Output: Jane Doe

runApp(const MinaApp());
}





class MinaApp extends StatelessWidget {
  const MinaApp({super.key});
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
