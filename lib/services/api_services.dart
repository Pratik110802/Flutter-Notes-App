import 'dart:convert';
import 'dart:developer';

import 'package:notes/models/notes.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseurl = "https://notes-app-g42f.onrender.com/";

  static Future<void> addNote(Note note) async {
    Uri requestUri = Uri.parse("${baseurl}notes/add");
    var response = await http.post(requestUri, body: note.toMap());
    var encode = json.encode(response.body);
    var decode = json.decode(encode);
    log(decode.toString());
  }

  static Future<void> deleteNote(Note note) async {
    Uri requestUri = Uri.parse("${baseurl}notes/delete");
    var response = await http.post(requestUri, body: note.toMap());
    var encode = json.encode(response.body);
    var decode = json.decode(encode);
    log(decode.toString());
  }

  static Future<List<Note>> fetchNotes(String userid) async {
    Uri requestUri = Uri.parse("${baseurl}notes/list");
    var response = await http.post(requestUri, body: {"userid": userid});

    var decode = json.decode(response.body);
    log(decode.toString());

    List<Note> notes = [];
    for (var noteMap in decode) {
      Note newNote = Note.fromMap(noteMap);
      notes.add(newNote);
    }
    return notes;
  }
}
