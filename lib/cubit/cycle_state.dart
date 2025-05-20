part of 'cycle_cubit.dart';

sealed class CycleState extends Equatable {
  final DateTime? currentPeriodStartDate;
  final DateTime? currentPeriodEndDate;
  const CycleState({this.currentPeriodStartDate, this.currentPeriodEndDate});

  @override
  List<Object> get props => [];
}

final class CycleInitial extends CycleState {}

final class NewPeriodDayStarted extends CycleState {
  const NewPeriodDayStarted({required DateTime newCycleStartDate})
      : super(currentPeriodStartDate: newCycleStartDate);
}

final class CurrentPeriodOngoing extends CycleState {
  const CurrentPeriodOngoing({required DateTime currentCycleStartDate})
      : super(currentPeriodStartDate: currentCycleStartDate);
}

final class PeriodEnded extends CycleState {
  const PeriodEnded(
      {required DateTime currentPeriodStartDate,
      required DateTime currentPeriodEndDate})
      : super(
            currentPeriodStartDate: currentPeriodStartDate,
            currentPeriodEndDate: currentPeriodEndDate);
}

final class CycleEnded extends CycleState {}
