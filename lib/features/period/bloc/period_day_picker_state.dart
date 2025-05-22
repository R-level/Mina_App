import 'package:equatable/equatable.dart';

enum PeriodDayPickerStatus { initial, loading, success, failure }

class PeriodDayPickerState extends Equatable {
  final PeriodDayPickerStatus status;
  final Set<DateTime> selectedDays;
  final Set<DateTime> oldDays;

  const PeriodDayPickerState({
    this.status = PeriodDayPickerStatus.initial,
    this.selectedDays = const {},
    this.oldDays = const {},
  });

  PeriodDayPickerState copyWith({
    PeriodDayPickerStatus? status,
    Set<DateTime>? selectedDays,
    Set<DateTime>? oldDays,
  }) {
    return PeriodDayPickerState(
      status: status ?? this.status,
      selectedDays: selectedDays ?? this.selectedDays,
      oldDays: oldDays ?? this.oldDays,
    );
  }

  @override
  List<Object> get props => [status, selectedDays, oldDays];
}
