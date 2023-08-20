part of 'search_surah_bloc.dart';

sealed class SearchSurahState extends Equatable {
  const SearchSurahState();

  @override
  List<Object> get props => [];
}

final class SearchSurahInitial extends SearchSurahState {}

final class SearchSurahLoading extends SearchSurahState {}

class SearchSurahLoaded extends SearchSurahState {
  final List<Datum> search;
  const SearchSurahLoaded(this.search);

  @override
  List<Object> get props => [search];
}

final class SearchSurahNotFound extends SearchSurahState {}

class SearchSurahError extends SearchSurahState {
  final String error;
  const SearchSurahError(this.error);

  @override
  List<Object> get props => [error];
}
