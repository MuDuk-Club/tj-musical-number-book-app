// models/song.dart (데이터 모델)
class Song {
  final String title;
  final String singer;
  final String tjNumber;
  final String kyNumber;
  final String img;

  Song({required this.title, required this.singer, required this.tjNumber, required this.kyNumber, required this.img});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'] ?? '',
      singer: json['singer'] ?? '',
      tjNumber: json['tj_number'] ?? '',
      kyNumber: json['ky_number'] ?? '',
      img: json['img'] ?? '',
    );
  }
}