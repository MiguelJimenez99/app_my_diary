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

  Future<void> createNoteProvider(
    String description,
    String userId,
  ) async {
    // Await the note creation (assuming it returns void)
    await noteService.createUserNote(description, userId);

    // You may need to refetch notes to get the new note with its id
    await fetchNotes();
    notifyListeners();
  }
}
