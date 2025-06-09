import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:app_my_diary/services/PhotoService.dart';
import 'package:flutter/widgets.dart';

class PhotoProvider extends ChangeNotifier {
  List<Photo> _photo = [];
  List<Photo> get photo => _photo;

  PhotoService photoService = PhotoService();

  Future<void> fetchPhoto() async {
    _photo = await photoService.getUserPhotos();
    notifyListeners();
  }

  Future<void> favoritePhotoProvider(String id) async {
    final isFavorite = await photoService.favoriteUserPhoto(id);

    final index = _photo.indexWhere((photo) => photo.id == id);
    if (index != -1) {
      _photo[index].isFavorite = isFavorite;
      notifyListeners();
    }
  }
}
