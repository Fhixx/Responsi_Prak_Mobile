import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants.dart';
import '../../data/models/show_model.dart';
import '../../data/services/favorite_service.dart';
import '../../data/services/game_service.dart';
import '../../core/widgets/show_image.dart';

class DetailPage extends StatefulWidget {
  final int showId;
  const DetailPage({super.key, required this.showId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _service = TvMazeService();
  late Future<ShowModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchShowDetail(widget.showId);
  }

  void _retry() {
    setState(() => _future = _service.fetchShowDetail(widget.showId));
  }

  Future<void> _toggleFavorite(ShowModel show) async {
    final added = await FavoriteService.toggle(show);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(added
            ? '${show.title} ditambahkan ke favorit'
            : '${show.title} dihapus dari favorit'),
        duration: const Duration(seconds: 2),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: FutureBuilder<ShowModel>(
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
                  const Text('Gagal memuat detail'),
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

  Widget _buildContent(ShowModel show) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 420,
            width: double.infinity,
            child: ShowImage(
              url: show.thumbnail,
              alignment: Alignment.topCenter,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  show.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  show.genre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  show.platform,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  show.realeasedate,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  show.publisher,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 4),
                Text(
                  show.developer.isEmpty ? '-' : show.developer.join(', '),
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text('Selamat menonton!'))),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Nonton'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ValueListenableBuilder(
                      valueListenable:
                          FavoriteService.box.listenable(keys: [show.id]),
                      builder: (context, box, _) {
                        final fav = box.containsKey(show.id);
                        return OutlinedButton(
                          onPressed: () => _toggleFavorite(show),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Colors.white24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Icon(
                            fav ? Icons.favorite : Icons.favorite_border,
                            color: fav ? AppColors.primary : Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  show.description.isEmpty ? 'Tidak ada ringkasan.' : show.description,
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
}
