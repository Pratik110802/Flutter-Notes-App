import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notes/constants/colors.dart';
import 'package:notes/provider/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/notes.dart';

class AddNewPage extends StatefulWidget {
  const AddNewPage({super.key, required this.isupdate, this.note});
  final bool isupdate;
  final Note? note;

  @override
  State<AddNewPage> createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  TextEditingController titlecontroller = TextEditingController();

  TextEditingController contentcontroller = TextEditingController();

  FocusNode noteFocus = FocusNode();

  void addNewNote() {
    String uniqueid = const Uuid().v1();
    Note newNote = Note(
        id: uniqueid,
        userid: "Pratik Patil",
        title: titlecontroller.text,
        content: contentcontroller.text,
        dateadded: DateTime.now());
    log(uniqueid);

    Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  void updateNote() {
    widget.note!.title = titlecontroller.text;
    widget.note!.content = contentcontroller.text;
    widget.note!.dateadded = DateTime.now();
    Provider.of<NotesProvider>(context, listen: false).updateNote(widget.note!);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isupdate) {
      titlecontroller.text = widget.note!.title!;
      contentcontroller.text = widget.note!.content!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (widget.isupdate) {
                  updateNote();
                } else {
                  addNewNote();
                }
              },
              icon: const Icon(Icons.check_rounded))
        ],
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          "What`s in your mind?",
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: titlecontroller,
              autofocus: (widget.isupdate == true) ? false : true,
              onSubmitted: ((value) {
                if (value != "") {
                  noteFocus.requestFocus();
                }
              }),
              style: const TextStyle(fontSize: 30),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Title",
                  hintStyle: TextStyle(fontWeight: FontWeight.w300)),
            ),
            Expanded(
              child: TextField(
                controller: contentcontroller,
                focusNode: noteFocus,
                maxLines: null,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Content",
                    hintStyle: TextStyle(fontWeight: FontWeight.w300)),
              ),
            )
          ],
        ),
      )),
    );
  }
}
