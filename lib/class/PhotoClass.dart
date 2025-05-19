// To parse this JSON data, do
//
//     final photo = photoFromJson(jsonString);

import 'dart:convert';

Photo photoFromJson(String str) => Photo.fromJson(json.decode(str));

String photoToJson(Photo data) => json.encode(data.toJson());

class Photo {
  String id;
  String photo;
  String title;
  String description;
  String createdAt;

  Photo({
    required this.id,
    required this.photo,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    id: json["_id"] ?? '',
    photo: json["photo"] ?? '',
    title: json["title"] ?? '',
    description: json["description"] ?? '',
    createdAt: json["createdAt"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": photo,
    "title": title,
    "description": description,
    "createdAt": createdAt,
  };
}
