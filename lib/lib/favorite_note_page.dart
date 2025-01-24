import 'package:flutter/material.dart';

import 'database_helper.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  List<Map<String, dynamic>> favoriteNotes = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteNotes();
  }

  Future<void> fetchFavoriteNotes() async {
    final data = await DBHelper.getFavoriteNotes();
    setState(() {
      favoriteNotes = data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorite Notes",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: favoriteNotes.isEmpty
          ? const Center(
        child: Text(
          "No favorite notes available.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: favoriteNotes.length,
        itemBuilder: (context, index) {
          final note = favoriteNotes[index];
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
