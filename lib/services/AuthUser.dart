import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {

  //https://back-my-diary-v2.onrender.com
  //http://192.168.1.42:3000
  static String baseUrl = 'http://192.168.1.42:3000';
 // static String baseUrl = 'https://back-my-diary-v2.onrender.com';

  Future<String> registerService(
    String name,
    String lastname,
    String username,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'lastname': lastname,
          'username': username,
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return '${data['message']}';
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        final error = jsonDecode(response.body);
        return '${error['message']}';
      } else {
        final error = jsonDecode(response.body);
        return '${error['message'] ?? response.body}';
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String> loginService(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return 'success';
      } else if (response.statusCode == 404) {
        final error = jsonDecode(response.body);
        return 'Email no registrado';
      } else if (response.statusCode == 401) {
        final error = jsonDecode(response.body);
        return 'Contraseña Incorrecta';
      } else {
        final error = jsonDecode(response.body);
        return 'Error: ${error['message'] ?? response.body}';
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
