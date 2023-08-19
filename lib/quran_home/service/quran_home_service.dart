import 'package:http/http.dart' as http;
import 'package:quran_app/utils/constant.dart';
import 'package:quran_app/utils/end_points.dart';

import '../../model/quran_surah_response.dart';

class QuranHomeService {
  http.Client baseClient = http.Client();
  
  Future<QuranSurahResponse?> fetchSurah() async {
    QuranSurahResponse? quranResponse;
    Uri url = Uri.parse(EndPoints.baseUrl);
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.get(url, headers: headers);
    print(response, response.body);
    if (response.statusCode == 200) {
      quranResponse = quranSurahResponseFromJson(response.body);
    } else {
      quranResponse = null;
    }
    return quranResponse;
  }
}
