import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'quran_surah_event.dart';
part 'quran_surah_state.dart';

class QuranSurahBloc extends Bloc<QuranSurahEvent, QuranSurahState> {
  String selectedQuranVersion;
  QuranSurahBloc({required selectedVersion})
      : selectedQuranVersion = selectedVersion,
        super(VersionDropdownState(selectedVersion: selectedVersion)) {
    on<VersionSelectedEvent>((event, emit) {
      selectedQuranVersion = event.version;
      emit(VersionDropdownState(selectedVersion: selectedQuranVersion));
    });
  }
}
