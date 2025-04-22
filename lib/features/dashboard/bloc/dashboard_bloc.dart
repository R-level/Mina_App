import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mina_app/data/repositories/cycle_repository.dart';
import 'package:mina_app/services/prediction_service.dart';
import 'package:mina_app/services/notification_service.dart';
import 'package:mina_app/data/database/databaseHelper.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {}

class RefreshDashboard extends DashboardEvent {}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DateTime? nextPeriodDate;
  final int averageCycleLength;
  final int averagePeriodLength;
  final double cycleRegularity;
  final List<dynamic> recentCycles;

  const DashboardLoaded({
    this.nextPeriodDate,
    required this.averageCycleLength,
    required this.averagePeriodLength,
    required this.cycleRegularity,
    required this.recentCycles,
  });

  @override
  List<Object?> get props => [
        nextPeriodDate,
        averageCycleLength,
        averagePeriodLength,
        cycleRegularity,
        recentCycles,
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final CycleRepository cycleRepository;
  final PredictionService _predictionService;
  final NotificationService _notificationService;
  final DatabaseHelper _dbHelper;

  DashboardBloc({
    required this.cycleRepository,
    PredictionService? predictionService,
    NotificationService? notificationService,
    DatabaseHelper? dbHelper,
  })  : _predictionService = predictionService ?? PredictionService(),
        _notificationService = notificationService ?? NotificationService(),
        _dbHelper = dbHelper ?? DatabaseHelper(),
        super(DashboardLoading()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(DashboardLoading());
      final stats = await _predictionService.getPredictionStats();
      final nextPeriod = await _predictionService.predictNextPeriod();
      final cycles = await cycleRepository.calculateCycleHistory();

      // Schedule notification if enabled
      final settings = await _dbHelper.getAllSettings();
      final enableReminders = settings['enable_period_reminders'] == 'true';
      final reminderDays = int.parse(settings['reminder_days'] ?? '2');

      if (enableReminders && nextPeriod != null) {
        await _notificationService.schedulePeriodReminder(nextPeriod);
      }

      emit(DashboardLoaded(
        nextPeriodDate: nextPeriod,
        averageCycleLength: stats['averageCycleLength'] as int,
        averagePeriodLength: stats['averagePeriodLength'] as int,
        cycleRegularity: stats['cycleRegularity'] as double,
        recentCycles: cycles,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    await _onLoadDashboard(LoadDashboard(), emit);
  }
}
