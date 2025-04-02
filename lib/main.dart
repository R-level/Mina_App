import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/features/dashboard/view/dashboard_view.dart';
import 'package:mina_app/data/model/model.dart';
import 'package:flutter/foundation.dart';



void main()  async {
WidgetsFlutterBinding.ensureInitialized();

 //Comment Out When showing UI 
  // <<section>>
  // Initialize FFI
  sqfliteFfiInit();
  // Set the database factory
  databaseFactory = databaseFactoryFfi;

final dbHelper = DatabaseHelper();
  var user = User( userId: 4,name: 'Janet Doel', email: 'janet.doel@example.com', age: 27, cycleLength: 29, periodLength: 4);
  await dbHelper.insertUser(user);

//var day = Day(date:DateTime.now(),cycleId:0,isPeriodDay: true, isPeriodStart:true,isPeriodEnd:  false, noteId:0);
//  await dbHelper.insertDayEntry(day);
 
  var storedUser = await dbHelper.getUser(4);
 // var storedDay = await dbHelper.getDayEntry(DateTime.now());
 //  var dayName = storedDay?.date.toString();
   if (kDebugMode) {
    debugPrint(storedUser?.name);
    
   // debugPrint(dayName);
  }
   // Output: Jane Doe
//Comment Out When showing UI
//<<section>>
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
      home:  Home(),
    );
  }
}
