import 'package:flutter/material.dart';

/// Label kecil untuk genre game.
/// [outlined] = true dipakai di halaman detail (versi bergaris tepi).
class GenreTag extends StatelessWidget {
  final String text;
  final bool outlined;

  const GenreTag(this.text, {super.key, this.outlined = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: outlined ? null : const Color(0xFF3A3A3C),
        borderRadius: BorderRadius.circular(4),
        border: outlined ? Border.all(color: Colors.white38) : null,
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: outlined ? 11 : 10, color: Colors.white70),
      ),
    );
  }
}
