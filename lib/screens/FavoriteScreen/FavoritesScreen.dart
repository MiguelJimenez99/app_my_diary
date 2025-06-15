import 'package:app_my_diary/class/PhotoClass.dart';
import 'package:app_my_diary/providers/PhotoProvider.dart';
import 'package:app_my_diary/providers/UserProvider.dart';
import 'package:app_my_diary/screens/FavoriteScreen/NoteFavoriteScreen.dart';
import 'package:app_my_diary/screens/FavoriteScreen/PhotoFavoriteScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:app_my_diary/class/NoteClass.dart';
import 'package:app_my_diary/class/UserClass.dart';
import 'package:app_my_diary/providers/NoteProvider.dart';

class MyFavoriteItemsScreen extends StatefulWidget {
  const MyFavoriteItemsScreen({super.key, required this.user});

  final User user;

  @override
  State<MyFavoriteItemsScreen> createState() => _MyFavoriteItemsScreenState();
}

class _MyFavoriteItemsScreenState extends State<MyFavoriteItemsScreen> {
  late List<Note> _favoriteNotes;
  late List<Photo> _favoritePhoto;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NoteProvider>(context, listen: false).fetchNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final providerNote = context.watch<NoteProvider>().notes;
    final providerPhotos = context.watch<PhotoProvider>().photo;

    _favoriteNotes =
        providerNote.where((note) => note.isFavorite == true).toList();
    _favoritePhoto =
        providerPhotos.where((photo) => photo.isFavorite == true).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(251, 248, 246, 1),
        centerTitle: true,
        title: Text(
          'Mis Favoritos',
          style: GoogleFonts.lato(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(251, 248, 246, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              NoteFavoriteScreen(user: user, favoriteNotes: _favoriteNotes),
              PhotoFavoriteScreen(favoritePhoto: _favoritePhoto),
            ],
          ),
        ),
      ),
    );
  }
}
