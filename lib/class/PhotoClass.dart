// To parse this JSON data, do
//
//     final photo = photoFromJson(jsonString);

import 'dart:convert';

Photo photoFromJson(String str) => Photo.fromJson(json.decode(str));

String photoToJson(Photo data) => json.encode(data.toJson());

class Photo {
  String id;
  String description;
  String url;
  bool? isFavorite;
  String cloudinaryId;
  String createdAt;

  Photo({
    required this.id,
    required this.description,
    required this.url,
    this.isFavorite = false,
    required this.cloudinaryId,
    required this.createdAt,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    id: json["_id"] ?? '',
    description: json["description"] ?? '',
    url: json["url"] ?? '',
    isFavorite: json["isFavorite"] ?? false,
    cloudinaryId: json["cloudinaryId"] ?? '',
    createdAt: json["createdAt"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "url": url,
    "isFavorite": isFavorite,
    "cloudinaryId": cloudinaryId,
    "createdAt": createdAt,
  };
}
