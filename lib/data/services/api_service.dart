import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../models/game_model.dart';

/// Fetch & parse data API dipisah dari UI.
class ApiService {
  static const Duration _timeout = Duration(seconds: 20);

  /// Daftar semua game: GET /games
  Future<List<GameModel>> fetchGames() async {
    final res =
        await http.get(Uri.parse('${AppConst.baseUrl}/games')).timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data (${res.statusCode})');
    }
    final List data = jsonDecode(res.body) as List;
    return data
        .map((e) => GameModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Detail game: GET /game?id={id}
  Future<GameModel> fetchGameDetail(int id) async {
    final res =
        await http.get(Uri.parse('${AppConst.baseUrl}/game?id=$id')).timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail (${res.statusCode})');
    }
    return GameModel.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
