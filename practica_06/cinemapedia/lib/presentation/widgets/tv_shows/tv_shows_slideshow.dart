import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';
import 'package:cinemapedia/presentation/providers/tv_shows/tv_shows_repository_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/media_slideshow.dart';

class TvShowsSlideshow extends ConsumerWidget {
  const TvShowsSlideshow({super.key, required this.shows});

  final List<TvShow> shows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final region = ref.watch(languageProvider).region;
    final repository = ref.watch(tvShowsRepositoryProvider);
    return MediaSlideshow<TvShow>(
      items: shows.take(5).toList(),
      imageUrl: (show) => show.backdropPath,
      route: (show) => '/home/0/tv-show/${show.id}',
      title: (show) => show.name,
      voteAverage: (show) => show.voteAverage,
      certification: (show) => repository.getCertificationById(show.id),
      certificationKey: (show) => 'tv-$region-${show.id}',
      previousLabel: 'Serie anterior',
      nextLabel: 'Serie siguiente',
    );
  }
}
