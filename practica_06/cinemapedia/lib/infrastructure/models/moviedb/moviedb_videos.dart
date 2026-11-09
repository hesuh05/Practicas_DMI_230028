class MoviedbVideosResponse {
  const MoviedbVideosResponse({required this.id, required this.results});

  final int id;
  final List<MoviedbVideoResult> results;

  factory MoviedbVideosResponse.fromJson(Map<String, dynamic> json) {
    final results = json['results'];
    return MoviedbVideosResponse(
      id: json['id'] as int,
      results: results is List
          ? results
              .whereType<Map<String, dynamic>>()
              .map(MoviedbVideoResult.fromJson)
              .toList()
          : const [],
    );
  }
}

class MoviedbVideoResult {
  const MoviedbVideoResult({
    required this.name,
    required this.key,
    required this.site,
    required this.publishedAt,
    required this.id,
  });

  final String name;
  final String key;
  final String site;
  final DateTime publishedAt;
  final String id;

  factory MoviedbVideoResult.fromJson(Map<String, dynamic> json) {
    return MoviedbVideoResult(
      name: json['name'] as String? ?? '',
      key: json['key'] as String? ?? '',
      site: json['site'] as String? ?? '',
      publishedAt:
          DateTime.tryParse(json['published_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      id: json['id'] as String? ?? '',
    );
  }
}
