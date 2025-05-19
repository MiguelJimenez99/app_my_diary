// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers, file_names

import 'package:flutter/material.dart';
import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:app_my_diary/services/PhotoService.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

  @override
  void initState() {
    // TODO: implement initState
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sharePhoto() {
    // ignore: deprecated_member_use
    Share.share(_photos[_currentIndex].photo);
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
                child: Text("Cancelar"),
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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF0F172A),
      ),
      backgroundColor: Color(0xFF0F172A),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.photos.length,
                itemBuilder: (context, index) {
                  final photo = widget.photos[index];
                  return InteractiveViewer(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Image.network(photo.photo),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: widget.photos.length,
                  effect: SwapEffect(
                    dotColor: Colors.white24,
                    activeDotColor: Colors.white,
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
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.white,
                    //     spreadRadius: 1,
                    //     blurRadius: 10,
                    //     offset: Offset(10, 10),
                    //   ),
                    // ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _sharePhoto,
                        icon: Icon(Icons.share, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: _delPhoto,
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                      ),
                    ],
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
