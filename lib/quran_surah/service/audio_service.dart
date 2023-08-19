import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioService {
  init(AudioPlayer audioPlayer, String source) async {
    await audioPlayer.setUrl(source);
  }

  Stream<PositionData> positionDataStream(AudioPlayer audioPlayer) {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        audioPlayer.positionStream,
        audioPlayer.bufferedPositionStream,
        audioPlayer.durationStream,
        (position, bufferedStream, duration) =>
            PositionData(position, bufferedStream, duration ?? Duration.zero));
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedStream;
  final Duration duration;

  const PositionData(this.position, this.bufferedStream, this.duration);
}
