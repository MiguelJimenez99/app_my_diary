import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_my_diary/services/PhotoService.dart';

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
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF0F172A),
      ),
      backgroundColor: Color(0xFF0F172A),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    'Cargar Imagen',
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 300,
                  width: double.infinity,
                  child:
                      _image == null
                          ? Center(
                            child: Text(
                              'No ha seleccionado ninguna imagen',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          )
                          : Image.file(File(_image!.path)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: _controllerDescription,
                    decoration: const InputDecoration(
                      labelText: 'Descripción (opcional)',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                      ),
                      onPressed: galleryImage,
                      icon: Icon(Icons.image, color: Colors.white),
                      label: Text(
                        'Galeria',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                      ),
                      onPressed: () async {
                        try {
                          await photoService.postPhotoUser(
                            imageFile: _image!,
                            description: _controllerDescription.text.trim(),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Imagen Guardada',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                            ),
                          );

                          await Future.delayed(Duration(seconds: 1));
                          Navigator.pop(context, true);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error al guardar la imagen',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.upload, color: Colors.white),
                      label: Text(
                        'Subir',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                      ),
                      onPressed: cameraImage,
                      icon: Icon(Icons.camera, color: Colors.white),
                      label: Text(
                        'Camara',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
