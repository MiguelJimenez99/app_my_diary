// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers, file_names

import 'package:app_my_diary/providers/PhotoProvider.dart';
import 'package:flutter/material.dart';
import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:app_my_diary/services/PhotoService.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoPhotoScreen extends StatefulWidget {
  const InfoPhotoScreen({
    super.key,
    required this.photos,
    required this.index,
    required this.dataPhoto,
  });

  final Photo dataPhoto;
  final List<Photo> photos;
  final int index;

  @override
  State<InfoPhotoScreen> createState() => _InfoPhotoScreenState();
}

class _InfoPhotoScreenState extends State<InfoPhotoScreen> {
  PhotoService photoService = PhotoService();
  late PageController _controller;
  int _currentIndex = 0;
  late List<Photo> _photos;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.photos);
    _currentIndex = widget.index;
    _controller = PageController(initialPage: _currentIndex);

    _controller.addListener(() {
      int newIndex = _controller.page?.round() ?? 0;
      if (newIndex != _currentIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
      }
    });
    Future.delayed(Duration.zero, () {
      Provider.of<PhotoProvider>(context, listen: false).fetchPhoto();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sharePhoto() {
    // ignore: deprecated_member_use
    photoService.SharePhotoFromUrl(_photos[_currentIndex].url);
  }

  void _isFavorite() async {
    try {
      final providerPhoto = Provider.of<PhotoProvider>(context, listen: false);
      await providerPhoto.favoritePhotoProvider(_photos[_currentIndex].id);

      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (error) {
      throw Exception('Error al actualizar el estado: $error');
    }
  }

  void _delPhoto() async {
    final confirm = await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('¿Eliminar foto?'),
            content: Text('¿Estás seguro de que deseas eliminar esta foto?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await photoService.delPhoto(_photos[_currentIndex].id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Eliminado correctamente',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromRGBO(53, 49, 149, 1),
        ),
      );
      await Future.delayed(Duration(seconds: 1));

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerPhoto = context.watch<PhotoProvider>();
    final notes = providerPhoto.photo.firstWhere(
      (photo) => photo.id == _photos[_currentIndex].id,
      orElse: () => widget.dataPhoto,
    );
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 248, 246, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.blueGrey,
        title: Text(
          'Detalle de Recuerdo',
          style: GoogleFonts.lato(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _isFavorite,
            icon: Icon(
              notes.isFavorite ?? false
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: notes.isFavorite ?? false ? Colors.red : Colors.grey,
              size: 30,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.black38),
            ),
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _photos.length,
                    itemBuilder: (context, index) {
                      final photo = _photos[index];
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),

                          child: ClipRRect(
                            child: Container(
                              color: Colors.grey[100],
                              child: InteractiveViewer(
                                child: Image.network(
                                  photo.url,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            progress.expectedTotalBytes != null
                                                ? progress
                                                        .cumulativeBytesLoaded /
                                                    progress.expectedTotalBytes!
                                                : null,
                                        color: Colors.blueGrey,
                                      ),
                                    );
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: _photos.length,
                    effect: SwapEffect(
                      dotColor: Colors.blueGrey[100]!,
                      activeDotColor: Colors.blueGrey,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                    onDotClicked: (index) {
                      _controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 24,
                    left: 24,
                    right: 24,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _sharePhoto,
                        icon: Icon(Icons.share, color: Colors.blueGrey[700]),
                        tooltip: 'Compartir',
                      ),
                      IconButton(
                        onPressed: _delPhoto,
                        icon: Icon(Icons.delete, color: Colors.red[400]),
                        tooltip: 'Eliminar',
                      ),
                      if (_photos[_currentIndex].description.isNotEmpty)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              _photos[_currentIndex].description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                color: Colors.blueGrey[800],
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
