class BookmarkModel {
  final String arabicText;
  final String editionText;
  final String? audio;

  BookmarkModel({
    required this.arabicText,
    required this.editionText,
    this.audio,
  });
}
