import 'package:http/http.dart' as http;
import 'package:quran_app/model/surah_details_response.dart';
import 'package:quran_app/utils/constant.dart';
import 'package:quran_app/utils/end_points.dart';

class QuranSurahService {
  http.Client baseClient = http.Client();

  Future<SurahDetailsResponse?> fetchSurahDetails(int surahNo) async {
    SurahDetailsResponse? surahDetailsResponse;
    Uri url = Uri.parse(EndPoints.surahDetailsEndPoint(surahNo));
    Map<String, String> headers = {"Content-Type": "application/json"};
    http.Response response = await http.get(url, headers: headers);
    print(response, response.body);
    if (response.statusCode == 200) {
      surahDetailsResponse = surahDetailsResponseFromJson(response.body);
    } else {
      surahDetailsResponse = null;
    }
    return surahDetailsResponse;
  }
}
