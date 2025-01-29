// pages/song_list_page.dart (메인 페이지 UI 및 데이터 핸들링)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tj_musical_number_book/widgets/song_category_panel.dart';
import 'package:tj_musical_number_book/services/data_service.dart';
import 'package:tj_musical_number_book/models/song.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  Map<String, bool> _expandedCategories = {};
  Map<String, List<Song>> musicalData = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await DataService.loadMusicalData();
    setState(() {
      musicalData = data;
      _expandedCategories = {for (var category in musicalData.keys) category: false};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('뮤지컬 노래방 번호', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: musicalData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '곡명, 작곡가, 가수 이름으로 검색',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: musicalData.keys.map((category) {
                  return SongCategoryPanel(
                    categoryTitle: category,
                    songs: musicalData[category]!.map((song) => {
                      'title': song.title,
                      'singer': song.singer,
                      'tj_number': song.tjNumber,
                      'ky_number': song.kyNumber,
                      'img': song.img,
                    }).toList(),
                    isExpanded: _expandedCategories[category] ?? false,
                    onExpansionChanged: () {
                      setState(() {
                        _expandedCategories[category] = !(_expandedCategories[category] ?? false);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}