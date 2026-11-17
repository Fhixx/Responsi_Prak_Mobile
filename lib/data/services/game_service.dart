import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../models/show_model.dart';

/// Fetch & parse data API dipisah dari UI.
class TvMazeService {
  Future<List<ShowModel>> fetchShows() async {
    final res = await http.get(Uri.parse('${AppConst.baseUrl}/games'));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data (${res.statusCode})');
    }
    final List data = jsonDecode(res.body) as List;
    return data
        .map((e) => ShowModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ShowModel> fetchShowDetail(int id) async {
    final res = await http.get(Uri.parse('${AppConst.baseUrl}/game?id=$id'));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail (${res.statusCode})');
    }
    return ShowModel.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
