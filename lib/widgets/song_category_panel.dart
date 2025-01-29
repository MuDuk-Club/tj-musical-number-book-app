import 'package:flutter/material.dart';
import 'package:tj_musical_number_book/theme/colors.dart';
import '../models/song.dart';
import '../services/song_service.dart';

class SongCategoryPanel extends StatelessWidget {
  final String categoryTitle;
  final List<Map<String, String>> songs;
  final bool isExpanded;
  final Function() onExpansionChanged;

  const SongCategoryPanel({
    super.key,
    required this.categoryTitle,
    required this.songs,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.all(0),
      expansionCallback: (int index, bool expanded) {
        onExpansionChanged();
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(categoryTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          },
          body: Column(
            children: songs.map((song) => Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ListTile(
                leading: Container(
                  width: 50.0, // 네모의 가로 크기
                  height: 50.0, // 네모의 세로 크기
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0), // 네모 모서리 둥글게
                  ),
                  child: Stack(
                    alignment: Alignment.center, // 이미지와 텍스트를 중앙에 배치
                    children: [
                      // 이미지
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0), // 네모 모서리 둥글게 설정
                        child: Image.asset(
                          './assets/imgs/logo/${song['img'] ?? 'default.png'}',  // 이미지 경로
                          fit: BoxFit.cover, // 이미지를 크기에 맞게 채움
                        ),
                      ),
                      // 검은색 반투명 오버레이
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0), // 네모 모서리 둥글게 설정
                        child: Container(
                          color: Colors.black.withOpacity(0.43), // 검은색의 43% 투명도
                        ),
                      ),
                      // 텍스트
                      Text(
                        song['tj_number'] ?? '',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.0, // 텍스트 크기 조정
                        ),
                      ),
                    ],
                  ),
                ),
                title: Text(song['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(song['singer']!),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.circleBorder),
                  onPressed: () async {
                    Song songToSave = Song(
                      title: song['title']!,
                      singer: song['singer']!,
                      tjNumber: song['tj_number']!,
                      kyNumber: song['ky_number']!,
                      img: song['img']!,
                    );
                    await saveSong(songToSave); // Song 객체를 저장
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"${song['title']}" 번호가 오늘 부를 넘버에 추가되었습니다.'),
                      ),
                    );
                  },
                ),
              ),
            )).toList(),
          ),
          isExpanded: isExpanded,
        ),
      ],
    );
  }
}
