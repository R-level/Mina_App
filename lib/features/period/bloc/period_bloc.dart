import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mina_app/data/model/model.dart';

class PeriodBloc extends Bloc<PeriodEvent, PeriodState> {
  PeriodBloc() : super(PeriodInitial());

  @override
  Stream<PeriodState> mapEventToState(
    PeriodEvent event,
  ) async* {
    if (event is PeriodStart) {
      yield PeriodStarted(date: DateTime.now());
    } else if (event is PeriodEnd) {
      yield PeriodEnded(date: DateTime.now());
    }
  }
}

abstract class PeriodEvent extends Equatable {
  final DateTime date;
  const PeriodEvent({required this.date});

  @override
  List<Object> get props => [date];
}

class PeriodStart extends PeriodEvent {
  const PeriodStart({required DateTime date}) : super(date: date);

  @override
  List<Object> get props => [date];
}

class PeriodEnd extends PeriodEvent {
  final DateTime date;

  const PeriodEnd(this.date) : super(date: date);

  @override
  List<Object> get props => [date];
}

class PeriodUpdated extends PeriodEvent {
  final PeriodDay period;
  final DateTime date;
  PeriodUpdated({required this.period, required this.date}) : super(date: date);

  @override
  List<Object> get props => [period];
}

//##Define the Period State
abstract class PeriodState extends Equatable {
  const PeriodState();

  @override
  List<Object> get props => [];
}

class PeriodInitial extends PeriodState {}

class PeriodStarted extends PeriodState {
  final DateTime date;

  const PeriodStarted({required this.date});

  @override
  List<Object> get props => [date];
}

class PeriodOnGoing extends PeriodState {
  const PeriodOnGoing();
}

class PeriodEnded extends PeriodState {
  final DateTime date;

  const PeriodEnded({required this.date});

  @override
  List<Object> get props => [date];
}
