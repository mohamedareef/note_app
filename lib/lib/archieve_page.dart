import 'package:flutter/material.dart';
import 'database_helper.dart';

class ArchieveScreen extends StatefulWidget {
  const ArchieveScreen({super.key});

  @override
  State<ArchieveScreen> createState() => ArchieveScreenState();
}

class ArchieveScreenState extends State<ArchieveScreen> {
  List<Map<String, dynamic>> archivedNotes = [];

  @override
  void initState() {
    super.initState();
    fetchArchivedNotes();
  }

  Future<void> fetchArchivedNotes() async {
    final data = await DBHelper.getArchivedNotes();
    setState(() {
      archivedNotes = data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Archived Notes",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: archivedNotes.isEmpty
          ? const Center(
        child: Text(
          "No archived notes available.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: archivedNotes.length,
        itemBuilder: (context, index) {
          final note = archivedNotes[index];
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
            ),
          );
        },
      ),
    );
  }
}
