import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:app_my_diary/services/PhotoService.dart';
import 'package:flutter/widgets.dart';

class PhotoProvider extends ChangeNotifier {
  List<Photo>? _photo = [];
  List<Photo>? get photo => _photo;

  PhotoService photoService = PhotoService();

  Future<void> fetchPhoto() async {
    _photo = await photoService.getUserPhotos();
    notifyListeners();
  }
}
