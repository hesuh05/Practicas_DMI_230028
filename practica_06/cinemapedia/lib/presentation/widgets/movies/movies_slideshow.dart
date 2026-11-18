import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/media_slideshow.dart';

class MoviesSlideshow extends ConsumerWidget {
  const MoviesSlideshow({super.key, required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final region = ref.watch(languageProvider).region;
    final repository = ref.watch(movieRepositoryProvider);
    return MediaSlideshow<Movie>(
      items: movies,
      imageUrl: (movie) => movie.backdropPath,
      route: (movie) => '/home/0/movie/${movie.id}',
      title: (movie) => movie.title,
      voteAverage: (movie) => movie.voteAverage,
      certification: (movie) => repository.getCertificationById(movie.id),
      certificationKey: (movie) => 'movie-$region-${movie.id}',
      previousLabel: 'Película anterior',
      nextLabel: 'Película siguiente',
    );
  }
}
