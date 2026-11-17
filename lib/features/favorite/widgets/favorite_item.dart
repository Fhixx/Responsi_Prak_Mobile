import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/widgets/show_image.dart';
import '../../../data/models/show_model.dart';
import '../../../data/services/favorite_service.dart';
import '../../detail/detail_page.dart';

class FavoriteItem extends StatelessWidget {
  final ShowModel show;
  const FavoriteItem({required this.show});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(showId: show.id)),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 48,
                height: 64,
                child: ShowImage(url: show.thumbnail),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    show.genre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.primary, size: 20),
              onPressed: () async {
                await FavoriteService.remove(show.id);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text('${show.title} dihapus dari favorit'),
                    duration: const Duration(seconds: 2),
                  ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
