class ShowModel {
  final int id;
  final String? title;
  final String? thumbnail;
  final String? genre;
  final String? platform;
  final String? description;
  // final List<String> developer;
  final String? publisher;
  final String? realeasedate;
  final String? developer;
  // final String? imageMedium;
  // final String? imageOriginal;
  // final double? rating;

  ShowModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.realeasedate,
    required this.description,
    // this.imageMedium,
    // this.imageOriginal,
    // this.rating,
    // this.developer = const [],
    required this.developer,
    // this.description = '',
  });

  /// Dari response API TVMaze.
  factory ShowModel.fromJson(Map<String, dynamic> json) {
    // final image = json['image'] as Map<String, dynamic>?;
    // // final ratingMap = json['rating'] as Map<String, dynamic>?;
    return ShowModel(
      id: json['id'] as int,
      title: (json['title'] ?? '-') as String?,
      thumbnail: (json['thumbnail'] ?? '-') as String?,
      genre: (json['genre'] ?? '-') as String?,
      platform: (json['platform'] ?? '-') as String?,
      publisher: (json['publisher'] ?? '-') as String?,
      realeasedate: (json['realease_date'] ?? '-') as String?,
      developer: (json['developer'] ?? '-') as String?,
      description: (json['description'] ?? '-') as String?,
      // imageMedium: _secure(image?['medium'] as String?),
      // imageOriginal: _secure(image?['original'] as String?),
      // // rating: (ratingMap?['average'] as num?)?.toDouble(),
      // developer: ((json['developer'] as List?) ?? []).map((e) => e.toString()).toList(),
      // description: _stripHtml(json['description'] as String?),
    );
  }

  /// Untuk disimpan di Hive (tanpa generator / adapter).
  Map<String, dynamic> toFavoriteMap() => {
        'id': id,
        'title': title,
        'thumbnail': thumbnail,
        'genre': genre,
        'platform': platform,
        'publisher': publisher,
        'realeasedate': realeasedate,
        // // 'rating': rating,
      };

  factory ShowModel.fromFavoriteMap(Map<String, dynamic> map) {
    return ShowModel(
      id: map['id'] as int,
      title: map['title'] as String,
      thumbnail: map['thumbnail'] as String,
      genre: map['genre'] as String,
      platform: map['platform'] as String,
      publisher: map['publisher'] as String,
      realeasedate: map['realease_date'] as String,
      developer: map['developer'] as String,
      description: map['description'] as String,
      // // rating: (map['rating'] as num?)?.toDouble(),
    );
  }

  // // // String get ratingText => rating != null ? rating!.toStringAsFixed(1) : '-';

  static String? _secure(String? url) =>
      url?.replaceFirst('http://', 'https://');

  static String _stripHtml(String? html) {
    if (html == null) return '';
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}
