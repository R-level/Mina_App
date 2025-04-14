import 'package:mina_app/features/day_entry/bloc/day_entry_event.dart';
import 'package:mina_app/features/day_entry/bloc/day_entry_state.dart';
import 'package:mina_app/data/repositories/day_entry_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';  

class DayEntryBloc extends Bloc<DayEntryBlocEvent, DayEntryBlocState> {
  DayEntryBloc() : super(const DayEntryInitialState()) {

    on<DayEntryFetch>((event, emit) async{
   
      emit(const DayEntryLoadingState());
        try{
          final day = await DayEntryRepository.instance.getDayEntry(event.date);
          if(day!=null){
          emit(DayEntryLoadedState(day));}
          else{
            //no day data exists for given day
            //new day entry will be created
            emit(const NewDayEntryState());
          }
        }catch(e){
          emit(const DayEntryErrorState('Failed to load day entry'));
        }
    });
  }
}