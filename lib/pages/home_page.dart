import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/colors.dart';
import 'package:notes/models/notes.dart';
import 'package:notes/pages/add_new_note.dart';
import 'package:notes/provider/notes_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    NotesProvider noteProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text("Notes"),
      ),
      body: (noteProvider.isloading == false)
          ? SafeArea(
              child: (noteProvider.notes.isNotEmpty)
                  ? ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(20)),
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  searchQuery = val;
                                });
                              },
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  contentPadding:
                                      EdgeInsets.only(top: 12, left: 15),
                                  hintText: "Search",
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        (noteProvider.getFilteredNotes(searchQuery).isNotEmpty)
                            ? GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: noteProvider
                                    .getFilteredNotes(searchQuery)
                                    .length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: ((context, index) {
                                  Note currentNote = noteProvider
                                      .getFilteredNotes(searchQuery)[index];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => AddNewPage(
                                                    isupdate: true,
                                                    note: currentNote,
                                                  )));
                                    },
                                    onLongPress: () {
                                      noteProvider.deleteNote(currentNote);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              const Color.fromARGB(
                                                  255, 32, 32, 32),
                                              primaryColor
                                            ],
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 20, right: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              maxLines: 1,
                                              currentNote.title.toString(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              softWrap: true,
                                              maxLines: 4,
                                              currentNote.content.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }))
                            : Center(
                                child: Text(
                                  "Not found 😕",
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 15),
                                ),
                              ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        "No Notes yet!😕",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                      ),
                    ))
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const AddNewPage(
                        isupdate: false,
                      ),
                  fullscreenDialog: true));
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
