import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/services/DiaryService.dart';
import 'package:flutter/material.dart';

class DiaryProvider extends ChangeNotifier {
  List<Diary>? _diary;
  bool _isLoading = false;

  List<Diary>? get diary => _diary;
  bool get isLoading => _isLoading;

  DiaryServices diaryServices = DiaryServices();

  // obtengo todos los datos del servicio de diary
  Future<void> fetchDiary() async {
    _isLoading = true;
    notifyListeners();

    _diary = await diaryServices.getDataActivity();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createEntryDiary(
    String title,
    String description,
    String mood,
    String date,
    String userId,
  ) async {
    final newEntryId = await diaryServices.newPostActivity(
      title,
      description,
      mood,
      date,
      userId,
    );

    // Option 1: If you have all the data, create a Diary object directly
    final newDiary = Diary(
      id: newEntryId,
      title: title,
      description: description,
      date: date,
      mood: mood,
      userId: userId,
    );

    _diary ??= [];
    _diary?.add(newDiary);
    notifyListeners();
  }

  Future<void> editEntriDiary(
    String id,
    String title,
    String description,
    String mood,
  ) async {
    await diaryServices.updateDiary(id, title, description, mood);

    final index = _diary?.indexWhere((entry) => entry.id == id);
    if (index != null && index >= 0) {
      final Diary old = _diary![index];
      _diary![index] = Diary(
        id: old.id,
        title: title,
        description: description,
        date: old.date,
        mood: mood,
        userId: old.userId,
      );
      notifyListeners();
    }
  }

  Future<void> deleteDiary(String id) async {
    await diaryServices.deleteDiary(id);
    _diary?.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}
