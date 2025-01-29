// main.dart (앱 진입점)
import 'package:flutter/material.dart';
import 'package:tj_musical_number_book/pages/song_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '뮤지컬 노래방',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const SongListPage(),
    );
  }
}