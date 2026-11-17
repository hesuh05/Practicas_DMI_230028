import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_rating.dart';

class MoviePosterLink extends ConsumerWidget {
  const MoviePosterLink({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteMovieStatusProvider(movie.id));
    return FadeInUp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => context.push('/home/0/movie/${movie.id}'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: const AssetImage(
                      'assets/loaders/wedge-loader.gif',
                    ),
                    image: NetworkImage(movie.posterPath),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: () async {
                    await ref
                        .read(favoriteMoviesProvider.notifier)
                        .toggleFavorite(movie);
                    ref.invalidate(favoriteMovieStatusProvider(movie.id));
                  },
                  icon: Icon(
                    isFavorite.value == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          MovieRating(voteAverage: movie.voteAverage),
        ],
      ),
    );
  }
}
