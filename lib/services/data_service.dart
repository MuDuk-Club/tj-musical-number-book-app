
// services/data_service.dart (데이터 로딩 서비스)
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tj_musical_number_book/models/song.dart';

class DataService {
  static Future<Map<String, List<Song>>> loadMusicalData() async {
    final String response = await rootBundle.loadString('assets/data/data.json');
    final data = json.decode(response);
    return (data['musicals'] as Map<String, dynamic>).map((key, value) {
      return MapEntry(key, (value as List).map((e) => Song.fromJson(e)).toList());
    });
  }
}
