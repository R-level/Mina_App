import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cycle_state.dart';

class CycleCubit extends Cubit<CycleState> {
  CycleCubit() : super(CycleInitial());

  //ToDo add functions to emit state for certain actions.
}
