import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/domain/entities/media_certification.dart';

class TvShowMapper {
  static TvEpisode episodeFromJson(Map<String, dynamic> json) => TvEpisode(
    episodeNumber: json['episode_number'] as int? ?? 0,
    name: json['name'] as String? ?? 'Episodio',
    overview: json['overview'] as String? ?? '',
    airDate: DateTime.tryParse(json['air_date'] as String? ?? ''),
    voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
  );

  static TvShow fromJson(Map<String, dynamic> json, {String region = ''}) {
    final firstAirDate = json['first_air_date'] as String?;
    final seasons = (json['seasons'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(
          (season) => TvSeason(
            seasonNumber: season['season_number'] as int? ?? 0,
            name: season['name'] as String? ?? 'Temporada',
            episodeCount: season['episode_count'] as int? ?? 0,
            airDate: DateTime.tryParse(season['air_date'] as String? ?? ''),
            overview: season['overview'] as String? ?? '',
          ),
        )
        .toList();
    return TvShow(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Sin título',
      overview: json['overview'] as String? ?? '',
      posterPath: _image(json['poster_path'] as String?),
      backdropPath: _backdrop(json['backdrop_path'] as String?),
      firstAirDate: firstAirDate == null || firstAirDate.isEmpty
          ? null
          : DateTime.tryParse(firstAirDate),
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: json['vote_count'] as int? ?? 0,
      numberOfSeasons: json['number_of_seasons'] as int? ?? 0,
      numberOfEpisodes: json['number_of_episodes'] as int? ?? 0,
      certification: certificationForRegion(json['content_ratings'], region),
    )..seasons = seasons;
  }

  static MediaCertification certificationForRegion(
    dynamic contentRatings,
    String region,
  ) {
    if (contentRatings is! Map<String, dynamic>) {
      return MediaCertification.empty(requestedRegion: region);
    }
    final results = contentRatings['results'];
    if (results is! List) {
      return MediaCertification.empty(requestedRegion: region);
    }

    MediaCertification? usFallback;
    MediaCertification? firstFallback;
    for (final item in results) {
      if (item is! Map<String, dynamic>) continue;
      final itemRegion = item['iso_3166_1']?.toString() ?? '';
      final code = item['rating']?.toString().trim() ?? '';
      if (itemRegion.isEmpty || code.isEmpty) continue;

      final candidate = MediaCertification(
        code: code,
        region: itemRegion,
        requestedRegion: region,
      );
      if (itemRegion == region) return candidate;
      if (itemRegion == 'US') usFallback ??= candidate;
      firstFallback ??= candidate;
    }

    return usFallback ??
        firstFallback ??
        MediaCertification.empty(requestedRegion: region);
  }

  static String _image(String? path) => path == null
      ? 'https://image.tmdb.org/t/p/w500/no-poster.jpg'
      : 'https://image.tmdb.org/t/p/w500$path';

  static String _backdrop(String? path) => path == null
      ? 'https://image.tmdb.org/t/p/w1280/no-poster.jpg'
      : 'https://image.tmdb.org/t/p/w1280$path';
}
