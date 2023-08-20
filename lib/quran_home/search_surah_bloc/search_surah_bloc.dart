import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quran_app/quran_home/service/quran_home_service.dart';

import '../../model/quran_surah_response.dart';

part 'search_surah_event.dart';
part 'search_surah_state.dart';

class SearchSurahBloc extends Bloc<SearchSurahEvent, SearchSurahState> {
  final QuranHomeService quranHomeService;
  SearchSurahBloc({required this.quranHomeService})
      : super(SearchSurahInitial()) {
    on<SearchLoadedEvent>((event, emit) async {
      try {
        List<Datum> searchSurah =
            await quranHomeService.searchQuranSurah(event.query);
        emit(SearchSurahLoading());
        if (searchSurah.isEmpty) {
          emit(SearchSurahNotFound());
        }else{
          emit(SearchSurahLoaded(searchSurah));
        }
      } catch (error) {
        emit(SearchSurahError(error.toString()));
      }
    });
  }
}
