import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/services/api_services.dart';

import '../models/notes.dart';

class NotesProvider with ChangeNotifier {
  bool isloading = true;
  List<Note> notes = [];
  NotesProvider() {
    fetchNotes();
    notifyListeners();
  }

  void sortNotes() {
    notes.sort(((a, b) => b.dateadded!.compareTo(a.dateadded!)));
    notifyListeners();
  }

  List<Note> getFilteredNotes(String searchQuery) {
    return notes
        .where((element) =>
            element.title!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            element.content!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  void addNote(Note note) {
    notes.add(note);
    sortNotes();
    notifyListeners();
    ApiService.addNote(note);
  }

  void updateNote(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote] = note;
    sortNotes();
    notifyListeners();
    ApiService.addNote(note);
  }

  void deleteNote(Note note) {
    int indexOfNote = notes.indexOf(notes.firstWhere((element) {
      log(element.id.toString());
      return element.id == note.id;
    }));
    log(indexOfNote.toString());
    notes.removeAt(indexOfNote);
    sortNotes();
    notifyListeners();
    ApiService.deleteNote(note);
  }

  void fetchNotes() async {
    notes = await ApiService.fetchNotes("Pratik Patil");
    isloading = false;
    sortNotes();
    notifyListeners();
  }
}
