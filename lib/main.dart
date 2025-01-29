import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:tj_musical_number_book/widgets/song_category_panel.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const SongListPage(),
    );
  }
}

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  Map<String, bool> _expandedCategories = {}; // 각 카테고리의 확장 상태를 관리

  Map<String, dynamic> musicalData = {}; // 실제 JSON 데이터가 들어올 타입

  // JSON 파일을 불러오는 함수
  Future<void> loadData() async {
    final String response = await rootBundle.loadString('./assets/data/data.json');
    final data = await json.decode(response);
    setState(() {
      musicalData = data['musicals']; // JSON에서 'musicals' 부분만 가져오기
      // 각 카테고리를 불러올 때 확장 상태를 false로 초기화
      _expandedCategories = {
        for (var category in musicalData.keys) category: false,
      };
    });
  }

  @override
  void initState() {
    super.initState();
    loadData(); // 앱이 시작할 때 JSON 데이터 로드
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          '뮤지컬 노래방 번호',
          style: TextStyle(color: Colors.white),
        ),
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
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '곡명, 작곡가, 가수 이름으로 검색',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: musicalData.keys.map((category) {
                  // 여기에서 `List<Map<String, dynamic>>` -> `List<Map<String, String>>`로 변환
                  var songs = (musicalData[category] as List<dynamic>)
                      .map<Map<String, String>>((e) {
                    return {
                      'title': e['title'] ?? '',
                      'singer': e['singer'] ?? '',
                      'tj_number': e['tj_number'] ?? '',
                      'ky_number': e['ky_number'] ?? '',
                      'img': e['img'] ?? ''
                    };
                  }).toList();

                  return SongCategoryPanel(
                    categoryTitle: category,
                    songs: songs,
                    isExpanded: _expandedCategories[category] ?? false, // 각 카테고리의 확장 상태
                    onExpansionChanged: () {
                      setState(() {
                        // 해당 카테고리의 확장 상태를 반전시킴
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
