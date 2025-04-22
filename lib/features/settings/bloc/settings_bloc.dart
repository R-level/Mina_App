import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/services/notification_service.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateNotificationSettings extends SettingsEvent {
  final bool enablePeriodReminders;
  final int reminderDays;

  const UpdateNotificationSettings({
    required this.enablePeriodReminders,
    required this.reminderDays,
  });

  @override
  List<Object?> get props => [enablePeriodReminders, reminderDays];
}

class UpdateTheme extends SettingsEvent {
  final String theme;

  const UpdateTheme({required this.theme});

  @override
  List<Object?> get props => [theme];
}

// States
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool enablePeriodReminders;
  final int reminderDays;
  final String theme;

  const SettingsLoaded({
    required this.enablePeriodReminders,
    required this.reminderDays,
    required this.theme,
  });

  @override
  List<Object?> get props => [enablePeriodReminders, reminderDays, theme];

  SettingsLoaded copyWith({
    bool? enablePeriodReminders,
    int? reminderDays,
    String? theme,
  }) {
    return SettingsLoaded(
      enablePeriodReminders:
          enablePeriodReminders ?? this.enablePeriodReminders,
      reminderDays: reminderDays ?? this.reminderDays,
      theme: theme ?? this.theme,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final DatabaseHelper _dbHelper;
  final NotificationService _notificationService;

  SettingsBloc({
    DatabaseHelper? dbHelper,
    NotificationService? notificationService,
  })  : _dbHelper = dbHelper ?? DatabaseHelper(),
        _notificationService = notificationService ?? NotificationService(),
        super(SettingsLoading()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateNotificationSettings>(_onUpdateNotificationSettings);
    on<UpdateTheme>(_onUpdateTheme);
  }

  Future<void> _onLoadSettings(
      LoadSettings event, Emitter<SettingsState> emit) async {
    try {
      final settings = await _dbHelper.getAllSettings();
      emit(SettingsLoaded(
        enablePeriodReminders: settings['enable_period_reminders'] == 'true',
        reminderDays: int.parse(settings['reminder_days'] ?? '2'),
        theme: settings['theme'] ?? 'system',
      ));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onUpdateNotificationSettings(
    UpdateNotificationSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _dbHelper.insertOrUpdateUserSetting(
        'enable_period_reminders',
        event.enablePeriodReminders.toString(),
      );
      await _dbHelper.insertOrUpdateUserSetting(
        'reminder_days',
        event.reminderDays.toString(),
      );

      if (state is SettingsLoaded) {
        emit((state as SettingsLoaded).copyWith(
          enablePeriodReminders: event.enablePeriodReminders,
          reminderDays: event.reminderDays,
        ));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onUpdateTheme(
      UpdateTheme event, Emitter<SettingsState> emit) async {
    try {
      await _dbHelper.insertOrUpdateUserSetting('theme', event.theme);

      if (state is SettingsLoaded) {
        emit((state as SettingsLoaded).copyWith(theme: event.theme));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
