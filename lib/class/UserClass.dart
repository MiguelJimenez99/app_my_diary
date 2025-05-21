// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  String name;
  String lastname;
  String username;
  String email;

  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"] as String,
    name: json["name"] ?? '',
    lastname: json["lastname"] ?? '',
    username: json["username"] ?? '',
    email: json["email"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lastname": lastname,
    "username": username,
    "email": email,
  };
}
