// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoNoteFAvorite extends StatelessWidget {
  const InfoNoteFAvorite({
    super.key,
    required this.provider,
    required this.note,
  });

  final provider;
  final note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Center(
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Center(
                  child: Text(
                    'Detalles',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 25,
                        decoration: TextDecoration.none,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.blueGrey[500]),
                    SizedBox(width: 10),
                    Text(
                      'Fecha:',
                      style: GoogleFonts.lato(
                        color: Colors.blueGrey[500],
                        fontSize: 17,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 30),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[600],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    note.date.substring(0, 10),
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  'Mi nota:',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 17,
                      color: Colors.blueGrey[500],
                    ),
                  ),
                ),
              ),
              note.description.isEmpty
                  ? Text('No hay datos')
                  : Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 30,
                      right: 30,
                    ),
                    child: Text(
                      note.description,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 25,
                          decoration: TextDecoration.none,
                          color: Colors.blueGrey[700],
                        ),
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
