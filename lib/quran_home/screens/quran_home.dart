import 'package:flutter/material.dart';
import 'package:quran_app/quran_home/service/quran_home_service.dart';
import 'package:quran_app/quran_surah/screens/quran_surah.dart';

import '../../utils/colors.dart';
import 'search_surah.dart';

class QuranHome extends StatefulWidget {
  const QuranHome({super.key});

  @override
  State<QuranHome> createState() => _QuranHomeState();
}

class _QuranHomeState extends State<QuranHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.background4,
      body: FutureBuilder(
          future: QuranHomeService().fetchSurah(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: CustomColors.background4,
                  color: CustomColors.background1,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: CustomColors.background1,
                    pinned: true,
                    title: const Text(
                      "Al-Qur'an",
                      style: TextStyle(
                        color: CustomColors.background4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            showSearch(
                                context: context, delegate: SearchSurah());
                          },
                          icon: const Icon(
                            Icons.search,
                            color: CustomColors.background4,
                          )),
                    ],
                  ),
                  SliverList.separated(
                    itemCount: snapshot.data!.data.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: CustomColors.background1,
                    ),
                    itemBuilder: (context, index) {
                      var surah = snapshot.data!.data[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => QuranSurah(surah: surah)));
                        },
                        title: Text(
                          surah.englishName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: CustomColors.background1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          surah.englishNameTranslation,
                          style: const TextStyle(
                            color: CustomColors.background2,
                          ),
                        ),
                        trailing: Text(
                          surah.name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: CustomColors.background1,
                            fontWeight: FontWeight.w500,
                          ),
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
