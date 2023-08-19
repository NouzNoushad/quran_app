part of 'quran_surah_bloc.dart';

sealed class QuranSurahEvent extends Equatable {
  const QuranSurahEvent();

  @override
  List<Object> get props => [];
}

class VersionSelectedEvent extends QuranSurahEvent {
  final String version;
  const VersionSelectedEvent(this.version);

  @override
  List<Object> get props => [version];
}
