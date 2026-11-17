import 'package:flutter/material.dart';
import '../constants.dart';

class ShowImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final Alignment alignment;

  const ShowImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  Widget _placeholder() => Container(
        color: AppColors.card,
        child: const Center(
          child: Icon(Icons.movie_outlined, color: Colors.white24, size: 32),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (url == null) return _placeholder();
    return Image.network(
      url!,
      fit: fit,
      alignment: alignment,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppColors.card,
          child: const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
}
