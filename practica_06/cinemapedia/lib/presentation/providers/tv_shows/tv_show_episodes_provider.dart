import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/tv_shows/tv_shows_repository_provider.dart';

final tvShowEpisodesProvider = FutureProvider.family
    .autoDispose<List<TvEpisode>, TvShowSeasonQuery>(
      (ref, query) => ref
          .watch(tvShowsRepositoryProvider)
          .getEpisodes(query.tvShowId, query.seasonNumber),
    );

class TvShowSeasonQuery {
  final String tvShowId;
  final int seasonNumber;

  const TvShowSeasonQuery(this.tvShowId, this.seasonNumber);

  @override
  bool operator ==(Object other) =>
      other is TvShowSeasonQuery &&
      other.tvShowId == tvShowId &&
      other.seasonNumber == seasonNumber;

  @override
  int get hashCode => Object.hash(tvShowId, seasonNumber);
}
