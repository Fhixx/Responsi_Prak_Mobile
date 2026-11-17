import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/services/favorite_service.dart';
import 'widgets/favorite_item.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Favorit')),
      body: ValueListenableBuilder(
        valueListenable: FavoriteService.box.listenable(),
        builder: (context, box, _) {
          final favorites = FavoriteService.getAll();
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada show favorit',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => FavoriteItem(show: favorites[i]),
          );
        },
      ),
    );
  }
}
