import 'package:flutter/material.dart';
import 'package:notes/screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      //themeMode: ThemeMode.system,
      theme: ThemeData(
          backgroundColor: const Color(0xFFFFFBFA),
          primaryColor: Colors.white, //const Color(0xFFFFFBFA),
          accentColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(brightness: Brightness.dark)),
      debugShowCheckedModeBanner: false,
      home: NoteList(),
    );
  }
}
