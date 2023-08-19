// To parse this JSON data, do
//
//     final quranSurahResponse = quranSurahResponseFromJson(jsonString);

import 'dart:convert';

QuranSurahResponse quranSurahResponseFromJson(String str) =>
    QuranSurahResponse.fromJson(json.decode(str));

String quranSurahResponseToJson(QuranSurahResponse data) =>
    json.encode(data.toJson());

class QuranSurahResponse {
  int code;
  String status;
  List<Datum> data;

  QuranSurahResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory QuranSurahResponse.fromJson(Map<String, dynamic> json) =>
      QuranSurahResponse(
        code: json["code"],
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int number;
  String name;
  String englishName;
  String englishNameTranslation;
  int numberOfAyahs;
  String revelationType;

  Datum({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        number: json["number"],
        name: json["name"],
        englishName: json["englishName"],
        englishNameTranslation: json["englishNameTranslation"],
        numberOfAyahs: json["numberOfAyahs"],
        revelationType: json["revelationType"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "numberOfAyahs": numberOfAyahs,
        "revelationType": revelationType,
      };
}