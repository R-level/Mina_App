import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:mina_app/data/database/databaseHelper.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  NotificationService._internal();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('app_icon');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notifications.initialize(initSettings);
  }

  Future<void> schedulePeriodReminder(DateTime periodDate) async {
    final settings = await _dbHelper.getAllSettings();
    final enableReminders = settings['enable_period_reminders'] == 'true';
    final reminderDays = int.parse(settings['reminder_days'] ?? '2');

    if (!enableReminders) return;

    final reminderDate = periodDate.subtract(Duration(days: reminderDays));

    await _notifications.zonedSchedule(
      1, // Use unique ID for period reminders
      'Upcoming Period',
      'Your next period may start in $reminderDays days',
      tz.TZDateTime.from(reminderDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'period_reminders',
          'Period Reminders',
          channelDescription: 'Notifications for upcoming periods',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          null, // Adjust if needed for daily/weekly scheduling
    );
  }

  Future<void> scheduleCustomReminder({
    required String title,
    required String body,
    required DateTime dateTime,
    required int id,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'custom_reminders',
          'Custom Reminders',
          channelDescription: 'Custom reminders set by the user',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          null, // Adjust if needed for daily/weekly scheduling
    );
  }

  Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingReminders() async {
    return await _notifications.pendingNotificationRequests();
  }
}
