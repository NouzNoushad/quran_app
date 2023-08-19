import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/quran_surah/service/audio_service.dart';

part 'audio_surah_event.dart';
part 'audio_surah_state.dart';

class AudioSurahBloc extends Bloc<AudioSurahEvent, AudioSurahState> {
  final AudioService audioService;
  final AudioPlayer audioPlayer;
  final String source;
  AudioSurahBloc(this.audioService, this.audioPlayer, this.source)
      : super(AudioSurahLoading()) {
    on<StartAudio>((event, emit) async {
      try {
        await audioService.init(audioPlayer, source);
      } catch (error) {
        emit(AudioSurahError(error.toString()));
      }
      await audioPlayer.stop();
      audioService.positionDataStream(audioPlayer).listen((event) {
        add(OnPlay(event.position, event.bufferedStream, event.duration));
      });
    });
    on<OnPlay>((event, emit) async {
      emit(event.positionStream.inSeconds > 0
          ? AudioSurahPlayed(event.positionStream, event.bufferedPositionStream,
              event.durationStream)
          : AudioSurahCompleted(event.durationStream));
    });
    on<Play>((event, emit) async {
      await audioPlayer.play();
    });
    on<Paused>((event, emit) async {
      final pauseState = (state as AudioSurahPlayed);
      await audioPlayer.pause();
      emit(AudioSurahPaused(pauseState.positionStream,
          pauseState.bufferedPositionStream, pauseState.durationStream));
    });
    on<OnSeek>((event, emit) async {
      final seekState = (state as AudioSurahPlayed);
      await audioPlayer.seek(event.position);
      emit(AudioSurahPlayed(seekState.positionStream,
          seekState.bufferedPositionStream, seekState.durationStream));
    });
    on<Resumed>((event, emit) async {
      final resumedState = (state as AudioSurahPaused);
      await audioPlayer.play();
      emit(AudioSurahPlayed(resumedState.positionStream,
          resumedState.bufferedPositionStream, resumedState.durationStream));
    });
  }
}
