import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/screens/DiaryScreen/EditDiaryScreen.dart';
import 'package:app_my_diary/services/DiaryService.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoDiaryScreen extends StatefulWidget {
  const InfoDiaryScreen({super.key, required this.diary});

  final Diary diary;

  @override
  State<InfoDiaryScreen> createState() => _InfoDiaryScreenState();
}

class _InfoDiaryScreenState extends State<InfoDiaryScreen> {
  late Diary _diary;
  DiaryServices diaryServices = DiaryServices();

  @override
  void initState() {
    super.initState();
    _diary = widget.diary;
  }

  String formatFechaManual(DateTime fecha) {
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final DateTime parsedDate = DateTime.parse(widget.diary.date);
    final String formattedDate = formatFechaManual(parsedDate);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.blueGrey[900],
        centerTitle: true,
        backgroundColor: Color.fromRGBO(251, 248, 246, 1),
        elevation: 0,
        title: Text(
          'Detalles',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.blueGrey[400],
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: GoogleFonts.lato(
                        color: Colors.blueGrey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        _diary.mood,
                        style: GoogleFonts.lato(
                          color: Colors.blueGrey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28),
                Text(
                  'Título',
                  style: GoogleFonts.lato(
                    color: Colors.blueGrey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  _diary.title,
                  style: GoogleFonts.lato(
                    color: Colors.blueGrey[900],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 28),
                Text(
                  'Descripción',
                  style: GoogleFonts.lato(
                    color: Colors.blueGrey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  _diary.description,
                  style: GoogleFonts.lato(
                    color: Colors.blueGrey[900],
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
