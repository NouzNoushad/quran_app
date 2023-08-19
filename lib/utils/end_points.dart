class EndPoints {
  static String baseUrl = "http://api.alquran.cloud/v1/surah";
  static String english = "en.asad";
  static String arabic = "equran-uthmani";
  static String audio = "ar.alafasy";
  static String malayalam = "ml.abdulhameed";
  static String hindi = "hi.hindi";
  static String tamil = "ta.tamil";

  static String surahDetailsEndPoint(int surahNo) {
    return "$baseUrl/$surahNo/editions/$arabic,$english,$malayalam,$hindi,$tamil,$audio";
  }
}
