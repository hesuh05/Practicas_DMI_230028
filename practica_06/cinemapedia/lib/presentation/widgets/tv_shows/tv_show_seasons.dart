import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class TvShowSeasons extends ConsumerWidget {
  const TvShowSeasons({
    super.key,
    required this.tvShowId,
    required this.seasons,
  });

  final String tvShowId;
  final List<TvSeason> seasons;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (seasons.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Temporadas', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...seasons
            .where((season) => season.seasonNumber > 0)
            .map((season) => _SeasonTile(tvShowId: tvShowId, season: season)),
      ],
    );
  }
}

class _SeasonTile extends ConsumerWidget {
  const _SeasonTile({required this.tvShowId, required this.season});

  final String tvShowId;
  final TvSeason season;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodes = ref.watch(
      tvShowEpisodesProvider(TvShowSeasonQuery(tvShowId, season.seasonNumber)),
    );
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(child: Text('${season.seasonNumber}')),
        title: Text(season.name),
        subtitle: Text('${season.episodeCount} episodios'),
        children: [
          episodes.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('No se pudieron cargar los episodios: $error'),
            ),
            data: (items) => Column(
              children: items
                  .map(
                    (episode) => ListTile(
                      dense: true,
                      title: Text('${episode.episodeNumber}. ${episode.name}'),
                      subtitle: episode.overview.isEmpty
                          ? null
                          : Text(
                              episode.overview,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
