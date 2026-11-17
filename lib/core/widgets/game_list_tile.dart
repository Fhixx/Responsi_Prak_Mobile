import 'package:flutter/material.dart';
import '../../data/models/game_model.dart';
import '../constants.dart';
import 'game_image.dart';
import 'genre_tag.dart';

/// Satu baris game: thumbnail, nama, genre, platform + widget [trailing].
/// Dipakai di Home (trailing = panah) dan Library (trailing = tombol hapus).
class GameListTile extends StatelessWidget {
  final GameModel game;
  final VoidCallback onTap;
  final Widget trailing;

  const GameListTile({
    super.key,
    required this.game,
    required this.onTap,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 84,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: 96, child: GameImage(url: game.thumbnail)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    GenreTag(game.genre),
                    const SizedBox(height: 4),
                    Text(
                      game.platform,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: Colors.white54),
                    ),
                  ],
                ),
              ),
              trailing,
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
