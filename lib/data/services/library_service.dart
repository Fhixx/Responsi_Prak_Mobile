import 'package:hive_flutter/hive_flutter.dart';
import '../models/game_model.dart';

/// Library (game yang dimiliki user) disimpan & dikelola dengan Hive.
/// key = id game, value = Map data ringkas game + 'addedAt'.
class LibraryService {
  static const String boxName = 'library';

  static Box get box => Hive.box(boxName);

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static bool contains(int id) => box.containsKey(id);

  /// Jumlah game di library (dipakai halaman Profil).
  static int get count => box.length;

  static Future<void> add(GameModel game) {
    final map = game.toLibraryMap()
      ..['addedAt'] = DateTime.now().millisecondsSinceEpoch;
    return box.put(game.id, map);
  }

  static Future<void> remove(int id) => box.delete(id);

  /// Semua game di library, urut dari yang pertama ditambahkan.
  static List<GameModel> getAll() {
    final entries = box.values
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    entries.sort((a, b) =>
        ((a['addedAt'] as int?) ?? 0).compareTo((b['addedAt'] as int?) ?? 0));
    return entries.map(GameModel.fromLibraryMap).toList();
  }
}
