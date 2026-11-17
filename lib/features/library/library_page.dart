import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants.dart';
import '../../core/widgets/game_list_tile.dart';
import '../../data/models/game_model.dart';
import '../../data/services/library_service.dart';
import '../detail/detail_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  Future<void> _remove(BuildContext context, GameModel game) async {
    await LibraryService.remove(game.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('${game.title} dihapus dari Library'),
        duration: const Duration(seconds: 2),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library Anda')),
      body: ValueListenableBuilder(
        valueListenable: LibraryService.box.listenable(),
        builder: (context, box, _) {
          final games = LibraryService.getAll();
          if (games.isEmpty) {
            return const Center(
              child: Text(
                'Library masih kosong',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: games.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final game = games[i];
              return GameListTile(
                game: game,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(gameId: game.id)),
                ),
                trailing: IconButton(
                  tooltip: 'Hapus dari Library',
                  icon: const Icon(Icons.delete, color: AppColors.danger, size: 22),
                  onPressed: () => _remove(context, game),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
