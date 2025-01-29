import 'package:flutter/material.dart';
import 'package:tj_musical_number_book/models/song.dart';
import 'package:tj_musical_number_book/theme/colors.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final int index;
  final VoidCallback onDelete;

  const SongCard({
    Key? key,
    required this.song,
    required this.index,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(index.toString()),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${index + 1}',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(width: 8.0),
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
        title: Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(song.singer),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: AppColors.circleBorder),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
