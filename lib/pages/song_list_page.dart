// pages/song_list_page.dart (메인 페이지 UI 및 데이터 핸들링)
import 'package:flutter/material.dart';
import 'package:tj_musical_number_book/widgets/song_category_panel.dart';
import 'package:tj_musical_number_book/services/data_service.dart';
import 'package:tj_musical_number_book/models/song.dart';
import 'package:tj_musical_number_book/theme/colors.dart';
import 'package:tj_musical_number_book/pages/today_song_page.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  Map<String, bool> _expandedCategories = {}; // 카테고리 확장 상태
  Map<String, List<Song>> musicalData = {}; // 전체 데이터
  String searchQuery = ''; // 검색어

  @override
  void initState() {
    super.initState();
    loadData(); // 초기 데이터 로드
  }

  // 데이터 로드
  Future<void> loadData() async {
    final data = await DataService.loadMusicalData();
    setState(() {
      musicalData = data; // 데이터 저장
      _expandedCategories = {
        for (var category in musicalData.keys) category: false
      }; // 카테고리 초기화
    });
  }

  // 검색에 맞는 노래를 필터링
  List<Song> _getFilteredSongs() {
    List<Song> allSongs = [];
    musicalData.forEach((category, songs) {
      allSongs.addAll(songs);
    });

    if (searchQuery.isEmpty) {
      return allSongs; // 검색어가 없으면 전체 목록 반환
    }

    // 카테고리명도 검색 대상으로 포함하여 필터링
    List<Song> filteredSongs = [];
    musicalData.forEach((category, songs) {
      if (category.toLowerCase().contains(searchQuery.toLowerCase())) {
        // 카테고리명에 맞는 경우, 해당 카테고리의 모든 노래를 추가
        filteredSongs.addAll(songs);
      } else {
        // 카테고리명이 아니면 노래 제목, 가수명, 번호로 필터링
        filteredSongs.addAll(songs.where((song) {
          return song.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              song.singer.toLowerCase().contains(searchQuery.toLowerCase()) ||
              song.tjNumber.contains(searchQuery);
        }));
      }
    });

    return filteredSongs;
  }

  // 검색어 변경 시 호출되어 필터링된 결과를 업데이트
  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query; // 검색어 갱신
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        title:
            const Text('뮤지컬 노래방 번호', style: TextStyle(color: AppColors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.iconColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavedSongsPage()),
              );
            },
          ),
        ],
      ),
      body: musicalData.isEmpty
          ? const Center(
              child: CircularProgressIndicator()) // 데이터가 없으면 로딩 인디케이터
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _onSearchChanged, // 검색어 입력 시 _onSearchChanged 호출
                    decoration: InputDecoration(
                      hintText: '뮤지컬 이름, 곡명, 배우 이름으로 검색',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: AppColors.searchBorder),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: musicalData.keys.map((category) {
                        // 전체 데이터 또는 검색된 데이터에 맞춰서 노래 목록을 결정
                        List<Song> categorySongs = _getFilteredSongs()
                            .where(
                                (song) => musicalData[category]!.contains(song))
                            .toList();
                        if (categorySongs.isEmpty)
                          return Container(); // 필터링된 결과가 없으면 빈 컨테이너 반환

                        return SongCategoryPanel(
                          categoryTitle: category,
                          songs: categorySongs
                              .map((song) => {
                                    'title': song.title,
                                    'singer': song.singer,
                                    'tj_number': song.tjNumber,
                                    'ky_number': song.kyNumber,
                                    'img': song.img,
                                  })
                              .toList(),
                          isExpanded: _expandedCategories[category] ?? false,
                          onExpansionChanged: () {
                            setState(() {
                              _expandedCategories[category] =
                                  !(_expandedCategories[category] ?? false);
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
