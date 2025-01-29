import 'package:flutter/material.dart';
import 'package:tj_musical_number_book/models/song.dart';
import 'package:tj_musical_number_book/services/song_service.dart';
import 'package:tj_musical_number_book/theme/colors.dart';

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
    // 초기화: 저장된 노래 목록을 불러오기
    loadSavedSongs();
  }

  // 저장된 노래 목록을 불러오기
  Future<void> loadSavedSongs() async {
    savedSongs = await getSavedSongs();
    setState(() {});
  }

  // 드래그로 순서 변경 후 저장하기
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
          savedSongs = snapshot.data!;

          return ReorderableListView(
            onReorder: _onReorder,
            // 수정된 부분
            children: savedSongs
                .asMap()
                .map((index, song) {
                  return MapEntry(
                    index, // 인덱스를 key로 사용
                    Card(
                      key: ValueKey(index.toString()), // 고유한 Key 부여
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${index + 1}', // 1부터 시작하는 번호
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0, // 번호 텍스트 크기
                              ),
                            ),
                            SizedBox(width: 8.0), // 번호와 이미지 사이의 간격
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      './assets/imgs/logo/${song.img.isNotEmpty ? song.img : 'default.png'}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.43),
                                    ),
                                  ),
                                  Text(
                                    song.tjNumber,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        title: Text(song.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(song.singer),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: AppColors.circleBorder),
                          onPressed: () async {
                            await deleteSong(song);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('"${song.title}" 번호가 삭제되었습니다.'),
                              ),
                            );
                            loadSavedSongs();
                          },
                        ),
                      ),
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
