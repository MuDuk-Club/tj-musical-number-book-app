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

// SharedPreferences에서 저장된 Song 객체를 불러오는 함수
Future<List<Song>> getSavedSongs() async {
  final prefs = await SharedPreferences.getInstance();

  // SharedPreferences에서 저장된 노래 목록을 가져옴
  List<String>? songsJson = prefs.getStringList('saved_songs');

  if (songsJson != null) {
    // JSON 문자열을 Song 객체 리스트로 변환
    return songsJson.map((songJson) {
      return Song.fromJson(jsonDecode(songJson));
    }).toList();
  }

  return [];
}

// 노래 삭제하기
Future<void> deleteSong(Song song) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? songsJson = prefs.getStringList('saved_songs');

  if (songsJson != null) {
    // 노래 리스트에서 삭제할 노래를 제거
    songsJson.removeWhere((songData) {
      Song s = Song.fromJson(json.decode(songData));
      return s.tjNumber == song.tjNumber; // tjNumber를 기준으로 삭제
    });

    // 삭제된 리스트를 다시 저장
    await prefs.setStringList('saved_songs', songsJson);
  }
}

// 노래 순서 업데이트
Future<void> updateSongs(List<Song> songs) async {
  // SharedPreferences 인스턴스 가져오기
  final prefs = await SharedPreferences.getInstance();

  // Song 객체를 JSON 문자열로 변환
  List<String> songsJson =
      songs.map((song) => jsonEncode(song.toJson())).toList();

  // SharedPreferences에 저장
  await prefs.setStringList('saved_songs', songsJson);
}
