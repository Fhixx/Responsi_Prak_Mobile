import 'package:hive_flutter/hive_flutter.dart';
import '../models/show_model.dart';

/// Penyimpanan favorit dengan Hive (key = id show, value = Map).
class FavoriteService {
  static const String boxName = 'favorites';

  static Box get box => Hive.box(boxName);

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static bool isFavorite(int id) => box.containsKey(id);

  static Future<void> add(ShowModel show) => box.put(show.id, show.toFavoriteMap());

  static Future<void> remove(int id) => box.delete(id);

  static Future<bool> toggle(ShowModel show) async {
    if (isFavorite(show.id)) {
      await remove(show.id);
      return false;
    }
    await add(show);
    return true;
  }

  static List<ShowModel> getAll() {
    return box.values
        .map((e) => ShowModel.fromFavoriteMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
