import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/genre_tag.dart';
import '../../data/models/game_model.dart';
import '../../data/services/api_service.dart';
import '../../data/services/library_service.dart';

class DetailPage extends StatefulWidget {
  final int gameId;
  const DetailPage({super.key, required this.gameId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _service = ApiService();
  late Future<GameModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchGameDetail(widget.gameId);
  }

  void _retry() {
    setState(() => _future = _service.fetchGameDetail(widget.gameId));
  }

  Future<void> _getGame(GameModel game) async {
    await LibraryService.add(game);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('${game.title} ditambahkan ke Library'),
        duration: const Duration(seconds: 2),
      ));
  }

  void _openScreenshot(String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: InteractiveViewer(
          child: GameImage(url: url, fit: BoxFit.contain),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: FutureBuilder<GameModel>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (snap.hasError || !snap.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal memuat detail game'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _retry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          return _buildContent(snap.data!);
        },
      ),
    );
  }

  Widget _buildContent(GameModel game) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image: paling atas & besar
          AspectRatio(
            aspectRatio: 16 / 9,
            child: GameImage(url: game.thumbnail),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Genre & platform
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    GenreTag(game.genre, outlined: true),
                    Text(
                      game.platform,
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Nama game
                Text(
                  game.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Tanggal rilis, publisher, developer
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _info('Release Date', game.releaseDate),
                    _info('Publisher', game.publisher),
                    _info('Developer', game.developer),
                  ],
                ),
                const SizedBox(height: 16),
                // Tombol Get / In Library (UI berbeda sesuai kepemilikan)
                ValueListenableBuilder(
                  valueListenable: LibraryService.box.listenable(keys: [game.id]),
                  builder: (context, box, _) {
                    final owned = box.containsKey(game.id);
                    return SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: owned
                          ? ElevatedButton.icon(
                              onPressed: null,
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text('In Library'),
                              style: ElevatedButton.styleFrom(
                                disabledBackgroundColor: const Color(0xFF48484A),
                                disabledForegroundColor: Colors.white70,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () => _getGame(game),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Get'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                    );
                  },
                ),
                // Screenshots
                if (game.screenshots.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Screenshots',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: game.screenshots.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final url = game.screenshots[i];
                        return GestureDetector(
                          onTap: () => _openScreenshot(url),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: GameImage(url: url),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                // Deskripsi
                const SizedBox(height: 20),
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  game.description.isEmpty ? 'Tidak ada deskripsi.' : game.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38)),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
