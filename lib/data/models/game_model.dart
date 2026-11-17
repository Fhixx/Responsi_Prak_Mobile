/// Model game dari API FreeToGame.
///
/// - Endpoint list  (/games)     : id, title, thumbnail, genre, platform, ...
/// - Endpoint detail (/game?id=) : + description & screenshots
class GameModel {
  final int id;
  final String title;
  final String? thumbnail;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;
  final String description;
  final List<String> screenshots;

  const GameModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    this.description = '',
    this.screenshots = const [],
  });

  /// Dari response API.
  factory GameModel.fromJson(Map<String, dynamic> json) {
    final shots = (json['screenshots'] as List?) ?? const [];
    return GameModel(
      id: json['id'] as int,
      title: _str(json['title']),
      thumbnail: json['thumbnail'] as String?,
      genre: _str(json['genre']),
      platform: _str(json['platform']),
      publisher: _str(json['publisher']),
      developer: _str(json['developer']),
      releaseDate: _str(json['release_date']), // key API: release_date
      description: _str(json['description'] ?? json['short_description'], fallback: ''),
      screenshots: shots
          .map((e) => (e as Map)['image'])
          .whereType<String>()
          .toList(),
    );
  }

  /// Untuk disimpan di Hive (tanpa generator / adapter).
  /// Deskripsi & screenshot tidak disimpan: detail selalu diambil ulang dari API.
  Map<String, dynamic> toLibraryMap() => {
        'id': id,
        'title': title,
        'thumbnail': thumbnail,
        'genre': genre,
        'platform': platform,
        'publisher': publisher,
        'developer': developer,
        'releaseDate': releaseDate,
      };

  factory GameModel.fromLibraryMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'] as int,
      title: _str(map['title']),
      thumbnail: map['thumbnail'] as String?,
      genre: _str(map['genre']),
      platform: _str(map['platform']),
      publisher: _str(map['publisher']),
      developer: _str(map['developer']),
      releaseDate: _str(map['releaseDate']),
    );
  }

  static String _str(dynamic value, {String fallback = '-'}) {
    final s = value?.toString().trim();
    if (s == null || s.isEmpty) return fallback;
    return s;
  }
}
