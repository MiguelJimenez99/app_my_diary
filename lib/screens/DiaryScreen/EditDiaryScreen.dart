import 'package:app_my_diary/providers/DiaryProvider.dart';
import 'package:flutter/material.dart';
import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/services/DiaryService.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
        await Provider.of<DiaryProvider>(context, listen: false).editEntriDiary(
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
        foregroundColor: Colors.blueGrey[900],
        centerTitle: true,
        backgroundColor: Color.fromRGBO(251, 248, 246, 1),
        elevation: 0,
        title: Text(
          'Editar Entrada',
          style: GoogleFonts.lato(
            color: Colors.blueGrey[900],
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.blueGrey[900]),
      ),
      backgroundColor: Color.fromRGBO(251, 248, 246, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Título',
                    style: GoogleFonts.lato(
                      color: Colors.blueGrey[700],
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  _modernTextField(
                    controller: _controllerTitle,
                    hint: 'Título de la entrada',
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'No se pueden guardar un campo vacío'
                                : null,
                    maxLines: 1,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Descripción',
                    style: GoogleFonts.lato(
                      color: Colors.blueGrey[700],
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  _modernTextField(
                    controller: _controllerDescription,
                    hint: 'Describe tu día...',
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'No se pueden guardar un campo vacío'
                                : null,
                    maxLines: 5,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Estado Ánimo',
                    style: GoogleFonts.lato(
                      color: Colors.blueGrey[700],
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  _modernTextField(
                    controller: _controllerMood,
                    hint: '¿Cómo te sentiste?',
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'No se pueden guardar un campo vacío'
                                : null,
                    maxLines: 1,
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 6,
                        ),
                        onPressed: _updateDiary,
                        icon: Icon(Icons.save, color: Colors.white),
                        label: Text(
                          'Editar',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style: GoogleFonts.lato(
        color: Colors.blueGrey[900],
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: GoogleFonts.lato(color: Colors.blueGrey[300]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blueGrey[100]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Color.fromRGBO(53, 49, 149, 1),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      ),
      textInputAction: TextInputAction.next,
    );
  }
}
