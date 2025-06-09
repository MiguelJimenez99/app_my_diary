import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:app_my_diary/screens/GalleryScreens/InfoPhotoScreen.dart';

class PhotoFavoriteScreen extends StatelessWidget {
  const PhotoFavoriteScreen({super.key, required List<Photo> favoritePhoto})
    : _favoritePhoto = favoritePhoto;

  final List<Photo> _favoritePhoto;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 320),
              child: Container(
                width: double.maxFinite,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fotos Favoritas',
                        style: GoogleFonts.lato(
                          fontSize: 25,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                      // TextButton.icon(
                      //   style: TextButton.styleFrom(
                      //     backgroundColor: Colors.blueGrey,
                      //   ),
                      //   onPressed: () {},
                      //   label: Text(
                      //     'Ir a fotos',
                      //     style: GoogleFonts.lato(color: Colors.white),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Material(
                color: Color.fromRGBO(251, 248, 246, 1),
                child:
                    _favoritePhoto.isEmpty
                        ? Center(child: Text('No tienes Fotos favoritas'))
                        : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _favoritePhoto.length,
                          itemBuilder: (context, index) {
                            final photo = _favoritePhoto[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 250,
                                width: 250,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => InfoPhotoScreen(
                                              photos: _favoritePhoto,
                                              index: index,
                                              dataPhoto: photo,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    photo.url,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                          color: Colors.blueGrey,
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[300],
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.blueGrey[200],
                                                size: 60,
                                              ),
                                            ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ),
          ],
        );
      },
    );
  }
}
