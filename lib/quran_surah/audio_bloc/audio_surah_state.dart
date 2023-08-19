part of 'audio_surah_bloc.dart';

sealed class AudioSurahState extends Equatable {
  const AudioSurahState();

  @override
  List<Object> get props => [];
}

final class AudioSurahInitial extends AudioSurahState {}

class AudioSurahPlayed extends AudioSurahState {
  final Duration positionStream;
  final Duration bufferedPositionStream;
  final Duration durationStream;

  const AudioSurahPlayed(this.positionStream, this.bufferedPositionStream, this.durationStream);

  @override
  List<Object> get props => [positionStream, bufferedPositionStream, durationStream];
}

class AudioSurahPaused extends AudioSurahState {
  final Duration positionStream;
  final Duration bufferedPositionStream;
  final Duration durationStream;

  const AudioSurahPaused(
      this.positionStream, this.bufferedPositionStream, this.durationStream);

  @override
  List<Object> get props =>
      [positionStream, bufferedPositionStream, durationStream];
}

class AudioSurahCompleted extends AudioSurahState {
  final Duration duration;

  const AudioSurahCompleted(
      this.duration,);

  @override
  List<Object> get props =>
      [duration];
}

class AudioSurahError extends AudioSurahState {
  final String error;

  const AudioSurahError(
    this.error,
  );

  @override
  List<Object> get props => [error];
}

final class AudioSurahLoading extends AudioSurahState {}
