// To parse this JSON data, do
//
//     final diary = diaryFromJson(jsonString);

import 'dart:convert';

Diary diaryFromJson(String str) => Diary.fromJson(json.decode(str));

String diaryToJson(Diary data) => json.encode(data.toJson());

class Diary {
  String id;
  String title;
  String description;
  String date;
  String mood;
  String userId;

  Diary({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.mood,
    required this.userId,
  });

  factory Diary.fromJson(Map<String, dynamic> json) => Diary(
    id: json["_id"] ?? '',
    title: json["title"] ?? '',
    description: json["description"] ?? '',
    date: json["date"] ?? '',
    mood: json["mood"] ?? '',
    userId: json["userId"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "date": date,
    "mood": mood,
    "userId": userId,
  };
}
