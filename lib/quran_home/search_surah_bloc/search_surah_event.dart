part of 'search_surah_bloc.dart';

sealed class SearchSurahEvent extends Equatable {
  const SearchSurahEvent();

  @override
  List<Object> get props => [];
}

class SearchLoadedEvent extends SearchSurahEvent {
  final String query;
  const SearchLoadedEvent(this.query);

  @override
  List<Object> get props => [query];
}
