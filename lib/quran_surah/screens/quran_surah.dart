import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/quran_surah/service/quran_surah_service.dart';
import 'package:quran_app/utils/colors.dart';

import '../../model/quran_surah_response.dart';
import '../../utils/constant.dart';
import '../audio_bloc/audio_surah_bloc.dart';
import '../dropdown_bloc/quran_surah_bloc.dart';
import '../service/audio_service.dart';

class QuranSurah extends StatefulWidget {
  final Datum surah;
  const QuranSurah({super.key, required this.surah});

  @override
  State<QuranSurah> createState() => _QuranSurahState();
}

class _QuranSurahState extends State<QuranSurah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.background4,
      body: FutureBuilder(
          future: QuranSurahService().fetchSurahDetails(widget.surah.number),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: CustomColors.background4,
                  color: CustomColors.background1,
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: CustomColors.background1,
                    iconTheme:
                        const IconThemeData(color: CustomColors.background4),
                    actions: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark,
                            color: CustomColors.background4,
                          ))
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: CustomColors.background1,
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 18),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.surah.englishName,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    color: CustomColors.background4,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  widget.surah.name,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: CustomColors.background4,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 100,
                              child:
                                  BlocBuilder<QuranSurahBloc, QuranSurahState>(
                                builder: (context, state) {
                                  return DropdownButton(
                                      dropdownColor: CustomColors.background1,
                                      hint: const Text('Editions'),
                                      underline: Container(),
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: CustomColors.background4,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      value: (state as VersionDropdownState)
                                          .selectedVersion,
                                      borderRadius: BorderRadius.circular(20),
                                      items: editions
                                          .map((edition) => DropdownMenuItem(
                                              value: edition,
                                              child: Center(
                                                child: Text(
                                                  edition,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: CustomColors
                                                          .background4),
                                                ),
                                              )))
                                          .toList(),
                                      onChanged: (version) {
                                        context.read<QuranSurahBloc>().add(
                                            VersionSelectedEvent(version!));
                                      });
                                },
                              ),
                            ),
                          ]),
                    ),
                  ),
                  SliverList.separated(
                    itemCount: snapshot.data!.data[0].ayahs.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: CustomColors.background1,
                    ),
                    itemBuilder: (context, index) {
                      var arabic = snapshot.data!.data[0].ayahs[index];
                      var english = snapshot.data!.data[1].ayahs[index];
                      var malayalam = snapshot.data!.data[2].ayahs[index];
                      var hindi = snapshot.data!.data[3].ayahs[index];
                      var tamil = snapshot.data!.data[4].ayahs[index];
                      var audio = snapshot.data!.data[5].ayahs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: BlocBuilder<QuranSurahBloc, QuranSurahState>(
                          builder: (context, state) {
                            var edition =
                                (state as VersionDropdownState).selectedVersion;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BlocProvider(
                                      create: (context) => AudioSurahBloc(
                                          AudioService(),
                                          AudioPlayer(),
                                          audio.audio.toString())
                                        ..add(StartAudio()),
                                      child: BlocConsumer<AudioSurahBloc,
                                          AudioSurahState>(
                                        listener: (context, state) {
                                          if (state is AudioSurahError) {}
                                        },
                                        builder: (context, state) {
                                          if (state is AudioSurahLoading) {
                                            return const CircularProgressIndicator(
                                              backgroundColor:
                                                  CustomColors.background4,
                                              color: CustomColors.background1,
                                            );
                                          }
                                          if (state is AudioSurahCompleted) {
                                            return audioButton(
                                                isPlay: false,
                                                onTap: () {
                                                  context
                                                      .read<AudioSurahBloc>()
                                                      .add(Play());
                                                });
                                          }
                                          if (state is AudioSurahPlayed) {
                                            return audioButton(
                                                isPlay: true,
                                                onTap: () {
                                                  context
                                                      .read<AudioSurahBloc>()
                                                      .add(Paused());
                                                });
                                          }
                                          if (state is AudioSurahPaused) {
                                            return audioButton(
                                                isPlay: false,
                                                onTap: () {
                                                  context
                                                      .read<AudioSurahBloc>()
                                                      .add(Resumed());
                                                });
                                          }
                                          return Container();
                                          // return const Text(
                                          //   'Something went wrong',
                                          //   style: TextStyle(
                                          //     fontSize: 16,
                                          //     color:
                                          //         CustomColors.background1,
                                          //   ),
                                          // );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        arabic.text,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: CustomColors.background1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  edition == 'Malayalam'
                                      ? malayalam.text
                                      : edition == 'English'
                                          ? english.text
                                          : edition == 'Hindi'
                                              ? hindi.text
                                              : tamil.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: CustomColors.background1,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.background1,
                ),
              ),
            );
          }),
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
