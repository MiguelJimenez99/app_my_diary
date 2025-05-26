import 'package:flutter/material.dart';
import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:app_my_diary/screens/GalleryScreens/InfoPhotoScreen.dart';
import 'package:app_my_diary/screens/GalleryScreens/UploadPhotoScreen.dart';
import 'package:app_my_diary/services/PhotoService.dart';
import 'package:google_fonts/google_fonts.dart';

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mis Recuerdos',
                          style: GoogleFonts.lato(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tu galería personal',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Divider(thickness: 1.2),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 670,
                      child: FutureBuilder<List<Photo>>(
                        future: _photos,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF355195),
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                '${snapshot.error}',
                                style: TextStyle(
                                  color: Colors.redAccent,
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
                                  color: Colors.black54,
                                  fontSize: 17,
                                ),
                              ),
                            );
                          } else {
                            final photos = snapshot.data!;
                            return GridView.builder(
                              itemCount: photos.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.85,
                                  ),
                              itemBuilder: (context, index) {
                                final photo = photos[index];
                                return ModernPhotoCard(
                                  photo: photo,
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
                                      _refreshScreen();
                                    }
                                  },
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
            Positioned(
              bottom: 30,
              right: 30,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF355195),
                elevation: 8,
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadPhotoScreen(),
                    ),
                  );
                  if (result == true) {
                    _refreshScreen();
                  }
                },
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modern Photo Card Widget
class ModernPhotoCard extends StatelessWidget {
  final Photo photo;
  final VoidCallback onTap;

  const ModernPhotoCard({Key? key, required this.photo, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.10),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Positioned.fill(
                child:
                    photo.url.isEmpty ||
                            !Uri.tryParse(photo.url)!.hasAbsolutePath
                        ? Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 40),
                          ),
                        )
                        : Image.network(
                          photo.url,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                strokeWidth: 3,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 40),
                              ),
                            );
                          },
                        ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.visibility,
                        color: Colors.white,
                        size: 18,
                      ),
                      photo.description.isNotEmpty
                          ? Text(photo.description)
                          : Text(''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// This widget represents a modern photo card with a shadow effect and a gradient background.
// It displays the photo with a description overlay and a loading indicator while the image is being fetched.