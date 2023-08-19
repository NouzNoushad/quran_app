part of 'quran_surah_bloc.dart';

sealed class QuranSurahState extends Equatable {
  const QuranSurahState();

  @override
  List<Object> get props => [];
}

final class VersionDropdownState extends QuranSurahState {
  final String? selectedVersion;
  const VersionDropdownState({this.selectedVersion});

  @override
  List<Object> get props => [selectedVersion!];
}
