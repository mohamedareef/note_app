// main.dart
import 'package:flutter/material.dart';
import 'package:node/lib/database_helper.dart';
import 'package:node/lib/notes_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DBHelper.deleteDB();
  await DBHelper.createDB();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Notes(),
    );
  }
}


