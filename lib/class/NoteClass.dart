// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

class Note {
  String id;
  String description;
  String date;
  String userId;
  String? createdAt;
  String? updatedAt;
  bool? isFavorite;

  Note({
    required this.id,
    required this.description,
    required this.date,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json["_id"],
    description: json["description"],
    date: json["date"],
    userId: json["userId"],
    createdAt: json["createdAt"] ?? '',
    updatedAt: json["updatedAt"] ?? '',
    isFavorite: json["isFavorite"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "date": date,
    "userId": userId,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "isFavorite": isFavorite,
  };

  // Note copyWith({String? id, String? description, bool? isFavorite}) {
  //   return Note(
  //     id: id ?? this.id,
  //     date: date,
  //     userId: userId,
  //     description: description ?? this.description,
  //     isFavorite: isFavorite ?? this.isFavorite,
  //   );
  // }
}
