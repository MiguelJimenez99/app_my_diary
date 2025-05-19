import 'package:flutter/material.dart';
import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:app_my_diary/screens/GalleryScreens/InfoPhotoScreen.dart';
import 'package:app_my_diary/screens/GalleryScreens/UploadPhotoScreen.dart';
import 'package:app_my_diary/services/PhotoService.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late Future<List<Photo>> _photos;

  PhotoService photoService = PhotoService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshScreen();
  }

  void _refreshScreen() {
    setState(() {
      _photos = photoService.getUserPhotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Color(0xFF0F172A)),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      'Mis Recuerdos',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: SizedBox(
                      height: 670,
                      child: FutureBuilder<List<Photo>>(
                        future: _photos,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                '${snapshot.error}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                'No hay actividad reciente',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            );
                          } else {
                            final photos = snapshot.data!;
                            return GridView.builder(
                              itemCount: photos.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                              itemBuilder: (context, index) {
                                final photo = photos[index];

                                if (photo.url.isEmpty ||
                                    !Uri.tryParse(
                                          photo.url,
                                        )!.hasAbsolutePath ==
                                        true) {
                                  // Mostrar imagen por defecto o un placeholder
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Icon(Icons.broken_image, size: 40),
                                    ),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => InfoPhotoScreen(
                                              photos: photos,
                                              index: index,
                                              dataPhoto: photo,
                                            ),
                                      ),
                                    );

                                    if (result == true) {
                                      setState(() {
                                        _refreshScreen();
                                      });
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      photo.url,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child; // Imagen cargada

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
                                                    : null, // Muestra progreso si es posible
                                          ),
                                        );
                                      },
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 40,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 25, right: 30, bottom: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(53, 49, 149, 1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadPhotoScreen(),
                        ),
                      );

                      if (result == true) {
                        setState(() {
                          _refreshScreen();
                        });
                      }
                    },
                    icon: Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
