import 'package:flutter/material.dart';
import 'package:mina_app/features/period/period_day_picker_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/features/dashboard/view/dashboard_view.dart';
import 'package:mina_app/features/auth/view/login_view.dart';
import 'package:mina_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  // await NotificationService().initialize();

  runApp(const MinaApp());
}

class MinaApp extends StatelessWidget {
  const MinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: true,
      home: StreamBuilder<bool>(
        stream: Stream.value(true), // Placeholder stream
        builder: (context, snapshot) {
          /*if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }*/

          //if (snapshot.hasData && snapshot.data == true) {
          return const DashboardView();
          //return PeriodDayPickerView();
          // }

          // return const LoginView();
        },
      ),
    );
  }
}
