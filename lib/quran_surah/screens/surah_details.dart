import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../model/boomark_model.dart';
import '../../utils/colors.dart';
import '../audio_bloc/audio_surah_bloc.dart';
import '../service/audio_service.dart';

class SurahDetails extends StatelessWidget {
  final BookmarkModel bookmark;
  const SurahDetails({
    super.key,
    required this.bookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocProvider(
              create: (context) => AudioSurahBloc(
                  AudioService(), AudioPlayer(), bookmark.audio.toString())
                ..add(StartAudio()),
              child: BlocConsumer<AudioSurahBloc, AudioSurahState>(
                listener: (context, state) {
                  if (state is AudioSurahError) {}
                },
                builder: (context, state) {
                  if (state is AudioSurahLoading) {
                    return Container();
                  }
                  if (state is AudioSurahCompleted) {
                    return audioButton(
                        isPlay: false,
                        onTap: () {
                          context.read<AudioSurahBloc>().add(Play());
                        });
                  }
                  if (state is AudioSurahPlayed) {
                    return audioButton(
                        isPlay: true,
                        onTap: () {
                          context.read<AudioSurahBloc>().add(Paused());
                        });
                  }
                  if (state is AudioSurahPaused) {
                    return audioButton(
                        isPlay: false,
                        onTap: () {
                          context.read<AudioSurahBloc>().add(Resumed());
                        });
                  }
                  return Container();
                },
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  bookmark.arabicText,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 20,
                    color: CustomColors.background1,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          bookmark.editionText,
          style: const TextStyle(
            fontSize: 16,
            color: CustomColors.background1,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget audioButton({required bool isPlay, void Function()? onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 16,
          backgroundColor: CustomColors.background3,
          child: Icon(
            isPlay ? Icons.pause : Icons.volume_up,
            size: 20,
            color: CustomColors.background4,
          ),
        ),
      );
}
