import 'package:isar/isar.dart';

part 'tv_show.g.dart';

class TvSeason {
  final int seasonNumber;
  final String name;
  final int episodeCount;
  final DateTime? airDate;
  final String overview;

  const TvSeason({
    required this.seasonNumber,
    required this.name,
    required this.episodeCount,
    required this.airDate,
    required this.overview,
  });
}

class TvEpisode {
  final int episodeNumber;
  final String name;
  final String overview;
  final DateTime? airDate;
  final double voteAverage;

  const TvEpisode({
    required this.episodeNumber,
    required this.name,
    required this.overview,
    required this.airDate,
    required this.voteAverage,
  });
}

@collection
class TvShow {
  Id? isarId;

  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final DateTime? firstAirDate;
  final double popularity;
  final double voteAverage;
  final int voteCount;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  @ignore
  List<TvSeason> seasons = const [];

  TvShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.firstAirDate,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
  });
}
