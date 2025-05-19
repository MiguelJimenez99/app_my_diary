import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_my_diary/class/DiaryClass.dart';
import 'package:app_my_diary/screens/DiaryScreen/EditDiaryScreen.dart';
import 'package:app_my_diary/services/DiaryService.dart';

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
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Color(0xFF0F172A),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: Color(0xFF0F172A)),
            SizedBox(
              height: 60,
              child: Center(
                child: Text(
                  'Detalles',
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 120, left: 30, right: 30),
              child: SizedBox(
                width: double.maxFinite,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(color: Colors.grey, fontSize: 17),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 6,
                          bottom: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(59, 58, 97, 1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          _diary.mood,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Titulo',
                        style: TextStyle(
                          color: Color.fromRGBO(53, 49, 149, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      _diary.title,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Descripcion',
                        style: TextStyle(
                          color: Color.fromRGBO(53, 49, 149, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      _diary.description,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
