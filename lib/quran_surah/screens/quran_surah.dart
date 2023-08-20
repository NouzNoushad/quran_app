import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/model/boomark_model.dart';
import 'package:quran_app/quran_surah/screens/surah_details.dart';
import 'package:quran_app/quran_surah/service/quran_surah_service.dart';
import 'package:quran_app/utils/colors.dart';

import '../../model/quran_surah_response.dart';
import '../../utils/constant.dart';
import '../dropdown_bloc/quran_surah_bloc.dart';

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
                            horizontal: 10, vertical: 15),
                        child: BlocBuilder<QuranSurahBloc, QuranSurahState>(
                          builder: (context, state) {
                            var edition =
                                (state as VersionDropdownState).selectedVersion;
                            BookmarkModel bookmark = BookmarkModel(
                              arabicText: arabic.text,
                              editionText: edition == 'Malayalam'
                                  ? malayalam.text
                                  : edition == 'English'
                                      ? english.text
                                      : edition == 'Hindi'
                                          ? hindi.text
                                          : tamil.text,
                              audio: audio.audio.toString(),
                            );
                            return SurahDetails(
                              bookmark: bookmark,
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
}
