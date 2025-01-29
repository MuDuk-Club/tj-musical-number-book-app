import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tj_musical_number_book/models/song.dart';

// Song 객체를 SharedPreferences에 저장하는 함수
Future<void> saveSong(Song song) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> savedSongsJson = prefs.getStringList('saved_songs') ?? [];

  // Song 객체를 JSON 문자열로 변환
  String songJson = json.encode(song.toJson());

  savedSongsJson.add(songJson);
  await prefs.setStringList('saved_songs', savedSongsJson);
}
