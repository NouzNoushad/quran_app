import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/quran_home/search_surah_bloc/search_surah_bloc.dart';
import 'package:quran_app/quran_home/service/quran_home_service.dart';

import '../../quran_surah/screens/quran_surah.dart';
import '../../utils/colors.dart';

class SearchSurah extends SearchDelegate {
  SearchSurah();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: CustomColors.background1,
      ),
      hintColor: CustomColors.background3,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: CustomColors.background4,
      ),
      inputDecorationTheme:
          const InputDecorationTheme(focusedBorder: InputBorder.none),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: CustomColors.background4,
          decorationThickness: 0.0000001,
        ),
      ),
    );
  }

  @override
  String? get searchFieldLabel => 'Search Surah';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(
          Icons.close,
          size: 20,
          color: CustomColors.background4,
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(
        Icons.arrow_back,
        size: 20,
        color: CustomColors.background4,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return suggestionList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return suggestionList();
  }

  Widget suggestionList() {
    return Material(
      color: CustomColors.background4,
      child: BlocProvider(
        create: (context) =>
            SearchSurahBloc(quranHomeService: QuranHomeService()),
        child: BlocBuilder<SearchSurahBloc, SearchSurahState>(
          builder: (context, state) {
            context.read<SearchSurahBloc>().add(SearchLoadedEvent(query));
            if (state is SearchSurahError) {
              return const Center(
                child: Text(
                  'Search Error',
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.background1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            if (state is SearchSurahLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: CustomColors.background4,
                  color: CustomColors.background1,
                ),
              );
            }
            if (state is SearchSurahLoaded) {
              return ListView.separated(
                itemCount: state.search.length,
                separatorBuilder: (context, index) => const Divider(
                  color: CustomColors.background1,
                ),
                itemBuilder: (context, index) {
                  var surah = state.search[index];
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
              );
            }
            if (state is SearchSurahNotFound) {
              return const Center(
                child: Text('Search Not Found',
                    style: TextStyle(
                      fontSize: 18,
                      color: CustomColors.background1,
                      fontWeight: FontWeight.w500,
                    )),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
