// models/song.dart (데이터 모델)
class Song {
  final String title;
  final String singer;
  final String tjNumber;
  final String kyNumber;
  final String img;

  Song({required this.title, required this.singer, required this.tjNumber, required this.kyNumber, required this.img});

  // JSON에서 Song 객체로 변환
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'] ?? '',
      singer: json['singer'] ?? '',
      tjNumber: json['tj_number'] ?? '',
      kyNumber: json['ky_number'] ?? '',
      img: json['img'] ?? '',
    );
  }

  // Song 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'singer': singer,
      'tj_number': tjNumber,
      'ky_number': kyNumber,
      'img': img,
    };
  }
}