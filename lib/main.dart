import 'package:flutter/material.dart';
import 'package:tj_musical_number_book/widgets/song_category_panel.dart'; // SongCategoryPanel 위젯 import

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
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;

  List<Map<String, String>> getSongsCategory1() {
    return [
      {'number': '82054', 'title': '게임의 시작', 'singer': '김준수'},
      {'number': '82129', 'title': '놈의 마음속으로', 'singer': '김준수 (한지상, 황광호)'},
    ];
  }

  List<Map<String, String>> getSongsCategory2() {
    return [
      {'number': '46897', 'title': '데스노트', 'singer': '홍광호'},
      {'number': '82177', 'title': '불쌍한 인간', 'singer': '박혜나, 강홍석'},
    ];
  }

  List<Map<String, String>> getSongsCategory3() {
    return [
      {'number': '82126', 'title': '비밀의 메시지', 'singer': '정선아'},
      {'number': '42384', 'title': '죽음의 게임', 'singer': '김준수 외'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final songsCategory1 = getSongsCategory1();
    final songsCategory2 = getSongsCategory2();
    final songsCategory3 = getSongsCategory3();

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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            // color: Colors.white38,
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
                children: [
                  // 첫 번째 카테고리
                  SongCategoryPanel(
                    categoryTitle: '카테고리 1',
                    songs: songsCategory1,
                    isExpanded: _isExpanded1,
                    onExpansionChanged: () {
                      setState(() {
                        _isExpanded1 = !_isExpanded1;
                      });
                    },
                  ),
                  // 두 번째 카테고리
                  SongCategoryPanel(
                    categoryTitle: '카테고리 2',
                    songs: songsCategory2,
                    isExpanded: _isExpanded2,
                    onExpansionChanged: () {
                      setState(() {
                        _isExpanded2 = !_isExpanded2;
                      });
                    },
                  ),
                  // 세 번째 카테고리
                  SongCategoryPanel(
                    categoryTitle: '카테고리 3',
                    songs: songsCategory3,
                    isExpanded: _isExpanded3,
                    onExpansionChanged: () {
                      setState(() {
                        _isExpanded3 = !_isExpanded3;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

