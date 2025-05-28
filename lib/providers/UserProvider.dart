import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/services/UserServices.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  final UserService userService = UserService();

  Future<void> fetchUser() async {
    _user = await userService.getDataUser();
    notifyListeners();
  }
}
