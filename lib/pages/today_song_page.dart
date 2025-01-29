import 'package:flutter/material.dart';
import 'package:tj_musical_number_book/models/song.dart';
import 'package:tj_musical_number_book/services/song_service.dart';
import 'package:tj_musical_number_book/theme/colors.dart';
import 'package:tj_musical_number_book/widgets/song_card.dart';

class SavedSongsPage extends StatefulWidget {
  const SavedSongsPage({super.key});

  @override
  _SavedSongsPageState createState() => _SavedSongsPageState();
}

class _SavedSongsPageState extends State<SavedSongsPage> {
  late List<Song> savedSongs;

  @override
  void initState() {
    super.initState();
    loadSavedSongs();
  }

  Future<void> loadSavedSongs() async {
    savedSongs = await getSavedSongs();
    setState(() {});
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1; // 인덱스가 하나씩 밀리는 문제 해결
      }
      final Song movedSong = savedSongs.removeAt(oldIndex);
      savedSongs.insert(newIndex, movedSong);
    });
    updateSongs(savedSongs); // 새로운 순서 저장
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘 부를 넘버',
            style: TextStyle(color: AppColors.blackMain)),
        backgroundColor: AppColors.white,
      ),
      body: FutureBuilder<List<Song>>(
        future: getSavedSongs(), // 저장된 노래들 불러오기
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('에러가 발생했습니다.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('저장된 노래가 없습니다.'));
          }

          savedSongs = snapshot.data!;

          return ReorderableListView(
            onReorder: _onReorder,
            children: savedSongs
                .asMap()
                .map((index, song) {
                  return MapEntry(
                    index,
                    SongCard(
                      key: ValueKey(index), // 여기에 key를 설정
                      song: song,
                      index: index,
                      onDelete: () async {
                        await deleteSong(song);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('"${song.title}" 번호가 삭제되었습니다.')),
                        );
                        loadSavedSongs();
                      },
                    ),
                  );
                })
                .values
                .toList(),
          );
        },
      ),
    );
  }
}
