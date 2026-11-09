import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final similarMoviesProvider = FutureProvider.family<List<Movie>, int>(
  (ref, movieId) => ref.watch(movieRepositoryProvider).getSimilarMovies(movieId),
);

class SimilarMovies extends ConsumerWidget {
  const SimilarMovies({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarMovies = ref.watch(similarMoviesProvider(movieId));
    return similarMovies.when(
      data: (movies) => movies.isEmpty
          ? const SizedBox.shrink()
          : MovieHorizontalListview(
              title: 'Recomendaciones',
              movies: movies,
            ),
      error: (_, _) => const SizedBox.shrink(),
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
