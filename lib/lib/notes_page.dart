import 'package:flutter/material.dart';
import 'archieve_page.dart';
import 'database_helper.dart';
import 'favorite_note_page.dart';
import 'new_note.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => NotesState();
}

class NotesState extends State<Notes> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  // Future<void> fetchNotes() async {
  //   final data = await DBHelper.getDataFromDB();
  //   setState(() {
  //     notes = data ?? [];
  //   });
  // }
  Future<void> fetchNotes() async {
    final data = await DBHelper.getDataFromDB();
    setState(() {

      notes = data?.where((note) => note['isArchived'] != 1).toList() ?? [];
    });
  }

  Future<void> deleteNote(int id) async {
    try {
      await DBHelper.deleteNoteById(id);
      fetchNotes();
    } catch (e) {
      print("Delete note error: $e");
    }
  }
  Future<void> archiveNote(int id) async {
    try {
      await DBHelper.updateArchiveStatus(id, 1);
      setState(() {
        notes.removeWhere((note) => note['id'] == id);
      });
    } catch (e) {
      print("Archive note error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.archive, color: Colors.grey),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ArchieveScreen()),
            );
          },
        ),
        title: const Text(
          "All Notes",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Favorites()),
              );
            },
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(
        child: Text(
          "No notes available.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(notes[index]['id']),
            background: Container(
              color: Colors.blue,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(
                Icons.archive,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                await archiveNote(notes[index]['id']);
                return false;
              } else if (direction == DismissDirection.endToStart) {
                await deleteNote(notes[index]['id']);
                return true;
              }
              return false;
            },
            child: noteItem(notes[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewNote(),
            ),
          );

          if (result != null) {
            await DBHelper.insertToDB(result["title"], result["note"]);
            fetchNotes();
          }
        },
        backgroundColor: Colors.grey[200],
        child: const Icon(
          Icons.add,
          color: Colors.grey,
          size: 30,
        ),
      ),
    );
  }

  Widget noteItem(Map<String, dynamic> note) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(
          note['Title'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(note['Note']),
        trailing: IconButton(
          icon: Icon(
            note['isFavorite'] == 1 ? Icons.favorite : Icons.favorite_border,
            color: Colors.redAccent,
          ),
          onPressed: () async {
            final newStatus = note['isFavorite'] == 1 ? 0 : 1;
            await DBHelper.updateFavoriteStatus(note['id'], newStatus);
            fetchNotes();
          },
        ),
      ),
    );
  }
}
