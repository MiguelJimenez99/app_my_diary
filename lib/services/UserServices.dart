import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_my_diary/class/UserClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService  {
  //https://back-my-diary-v2.onrender.com
  final String baseUrl = 'https://back-my-diary-v2.onrender.com';

  Future<User> getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token inválido o no encontrado.');
    }

    try {
      final url = Uri.parse('$baseUrl/api/user/me');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'authorization': token},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener los datos');
    }
  }

  Future<User> updateDataUser(
    String id,
    String name,
    String lastname,
    String username,
    String email,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token invalido o no encontrado');
      }

      final url = Uri.parse('$baseUrl/api/user/update/$id');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json', 'authorization': token},
        body: jsonEncode({
          'name': name,
          'lastname': lastname,
          'username': username,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else if (response.statusCode == 400) {
        throw Exception('Error: ${response.statusCode}');
      } else if (response.statusCode == 500) {
        throw Exception('Error interno del servidor.');
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al actualizar los datos');
    }
  }
}
