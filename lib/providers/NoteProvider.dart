import 'package:app_my_diary/class/NoteClass.dart';
import 'package:app_my_diary/services/NoteService.dart';
import 'package:flutter/foundation.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  NoteService noteService = NoteService();

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners();

    _notes = await noteService.getUserNotes();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createNoteProvider(String description, String userId) async {
    // Await the note creation (assuming it returns void)
    await noteService.createUserNote(description, userId);

    // You may need to refetch notes to get the new note with its id
    await fetchNotes();
    notifyListeners();
  }

  Future<void> updateNoteProvider(String description, String id) async {
    await noteService.updateUserNote(description, id);
    final index = _notes.indexWhere((entry) => entry.id == id);
    if (index >= 0) {
      final Note old = _notes[index];

      _notes[index] = Note(
        id: old.id,
        description: description,
        date: old.date,
        userId: old.userId,
      );
      notifyListeners();
    }
  }

  Future<void> favoriteNoteProvider(String id) async {
    final isFavorite = await noteService.favoriteUserNote(id);

    // Encuentra la nota en la lista y actualiza su estado
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index].isFavorite = isFavorite;
      // _notes[index] = notes[index].copyWith(isFavorite: isFavorite);
      notifyListeners();
    }
  }

  Future<void> deleteNoteProvider(String id) async {
    await noteService.deleteUserNote(id);

    _notes.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}
