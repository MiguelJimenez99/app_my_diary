import 'package:flutter/material.dart';
import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/services/DiaryService.dart';

class EditDiaryScreen extends StatefulWidget {
  const EditDiaryScreen({super.key, required this.diary});

  final Diary diary;

  @override
  State<EditDiaryScreen> createState() => _EditDiaryScreenState();
}

class _EditDiaryScreenState extends State<EditDiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  DiaryServices diaryServices = DiaryServices();

  late TextEditingController _controllerTitle;
  late TextEditingController _controllerDescription;
  late TextEditingController _controllerMood;

  @override
  void initState() {
    super.initState();
    _controllerTitle = TextEditingController(text: widget.diary.title);
    _controllerDescription = TextEditingController(
      text: widget.diary.description,
    );
    _controllerMood = TextEditingController(text: widget.diary.mood);
  }

  void _updateDiary() async {
    if (_formKey.currentState!.validate()) {
      try {
        await diaryServices.updateDiary(
          widget.diary.id,
          _controllerTitle.text.trim(),
          _controllerDescription.text.trim(),
          _controllerMood.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Editado correctamente',
              style: TextStyle(color: Colors.white, fontSize: 17),
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
              'Error al editar',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromRGBO(53, 49, 149, 1),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Color(0xFF0F172A),
      ),
      backgroundColor: Color(0xFF0F172A),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          width: double.maxFinite,
          decoration: BoxDecoration(color: Color(0xFF0F172A)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editar Entrada',
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 15),
                        child: Text(
                          'Titulo',
                          style: TextStyle(
                            color: Color.fromRGBO(53, 49, 149, 1),
                            fontSize: 25,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(color: Colors.white),
                        autofocus: true,
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'No se pueden guardar un campo vacio';
                          }
                          return null;
                        },
                        controller: _controllerTitle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Text(
                          'Descripcion',
                          style: TextStyle(
                            color: Color.fromRGBO(53, 49, 149, 1),
                            fontSize: 25,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'No se pueden guardar un campo vacio';
                          }
                          return null;
                        },
                        controller: _controllerDescription,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Text(
                          'Estado Animo',
                          style: TextStyle(
                            color: Color.fromRGBO(53, 49, 149, 1),
                            fontSize: 25,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 1,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'No se pueden guardar un campo vacio';
                          }
                          return null;
                        },
                        controller: _controllerMood,
                      ),

                      SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(53, 49, 149, 1),
                            ),
                            onPressed: _updateDiary,
                            child: Text(
                              'Editar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
