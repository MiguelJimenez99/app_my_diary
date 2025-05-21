import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/services/DiaryService.dart';
import 'package:flutter/material.dart';

class DiaryProvider extends ChangeNotifier {
  List<Diary>? _diary;

  List<Diary>? get diary => _diary;

  DiaryServices diaryServices = DiaryServices();

  Future<void> fetchDiary() async {
    _diary = await diaryServices.getDataActivity();
    notifyListeners();
  }
}
