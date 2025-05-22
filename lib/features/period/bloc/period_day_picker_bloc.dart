import 'package:flutter_bloc/flutter_bloc.dart';
import 'period_day_picker_event.dart';
import 'period_day_picker_state.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/data/model/day.dart';
import 'package:flutter/foundation.dart';

class PeriodDayPickerBloc
    extends Bloc<PeriodDayPickerEvent, PeriodDayPickerState> {
  PeriodDayPickerBloc() : super(const PeriodDayPickerState()) {
    on<PeriodDaysFetched>(_onFetched);
    on<PeriodDayToggled>(_onToggled);
  }

  Future<void> _onFetched(
    PeriodDaysFetched event,
    Emitter<PeriodDayPickerState> emit,
  ) async {
    emit(state.copyWith(status: PeriodDayPickerStatus.loading));
    try {
      final now = DateTime.now();
      List<Day> periodDays = await DatabaseHelper().getPeriodDaysInRange(
        DateTime(1960, 1, 1),
        DateTime(now.year + 1, now.month + 2, 0),
      );
      final Set<DateTime> processed =
          await compute(_processPeriodDaySetIsolate, periodDays);
      emit(state.copyWith(
        status: PeriodDayPickerStatus.success,
        oldDays: processed,
        selectedDays: processed,
      ));
    } catch (_) {
      emit(state.copyWith(status: PeriodDayPickerStatus.failure));
    }
  }

  void _onToggled(
    PeriodDayToggled event,
    Emitter<PeriodDayPickerState> emit,
  ) {
    final normalized = DateTime(event.day.year, event.day.month, event.day.day);
    final selected = Set<DateTime>.from(state.selectedDays);
    if (selected.contains(normalized)) {
      selected.remove(normalized);
    } else {
      selected.add(normalized);
    }
    emit(state.copyWith(selectedDays: selected));
  }

  static Set<DateTime> _processPeriodDaySetIsolate(List<Day> periodDays) {
    return periodDays
        .map((day) => DateTime(day.date.year, day.date.month, day.date.day))
        .toSet();
  }
}
