import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_my_diary/services/PhotoService.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  PhotoService photoService = PhotoService();

  final picker = ImagePicker();
  XFile? _image;
  final _controllerDescription = TextEditingController();

  Future<void> galleryImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = picked;
      });
    }
  }

  Future<void> cameraImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _image = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 248, 246, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(251, 248, 246, 1),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blueGrey[900]),
        title: Text(
          'Cargar Imagen',
          style: GoogleFonts.lato(
            color: Colors.blueGrey[900],
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Cargar Imagen',
                  style: GoogleFonts.lato(
                    color: Colors.blueGrey[800],
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.blueGrey[100]),
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.blueGrey.shade100,
                      width: 1,
                    ),
                  ),
                  child:
                      _image == null
                          ? Center(
                            child: Text(
                              'No ha seleccionado ninguna imagen',
                              style: GoogleFonts.lato(
                                color: Colors.blueGrey[400],
                                fontSize: 16,
                              ),
                            ),
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(
                              File(_image!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _controllerDescription,
                  decoration: InputDecoration(
                    labelText: 'Descripción (opcional)',
                    labelStyle: GoogleFonts.lato(color: Colors.blueGrey[400]),
                    filled: true,
                    fillColor: Colors.blueGrey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: GoogleFonts.lato(color: Colors.blueGrey[900]),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 0,
                          ),
                        ),
                        onPressed: galleryImage,
                        icon: Icon(Icons.image, color: Colors.white),
                        label: Text(
                          'Galería',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 0,
                          ),
                        ),
                        onPressed: cameraImage,
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                        label: Text(
                          'Cámara',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[700],
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 0,
                      ),
                    ),
                    onPressed:
                        _image == null
                            ? null
                            : () async {
                              try {
                                await photoService.postPhotoUser(
                                  imageFile: _image!,
                                  description:
                                      _controllerDescription.text.trim(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Imagen Guardada',
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.blueGrey[700],
                                  ),
                                );
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.pop(context, true);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error al guardar la imagen',
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                    icon: Icon(Icons.upload, color: Colors.white),
                    label: Text(
                      'Subir',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
