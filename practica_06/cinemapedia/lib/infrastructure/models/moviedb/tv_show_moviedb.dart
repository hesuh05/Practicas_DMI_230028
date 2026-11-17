import 'package:cinemapedia/domain/entities/tv_show.dart';

class TvShowMapper {
  static TvEpisode episodeFromJson(Map<String, dynamic> json) => TvEpisode(
    episodeNumber: json['episode_number'] as int? ?? 0,
    name: json['name'] as String? ?? 'Episodio',
    overview: json['overview'] as String? ?? '',
    airDate: DateTime.tryParse(json['air_date'] as String? ?? ''),
    voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
  );

  static TvShow fromJson(Map<String, dynamic> json) {
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
    )..seasons = seasons;
  }

  static String _image(String? path) => path == null
      ? 'https://image.tmdb.org/t/p/w500/no-poster.jpg'
      : 'https://image.tmdb.org/t/p/w500$path';

  static String _backdrop(String? path) => path == null
      ? 'https://image.tmdb.org/t/p/w1280/no-poster.jpg'
      : 'https://image.tmdb.org/t/p/w1280$path';
}
