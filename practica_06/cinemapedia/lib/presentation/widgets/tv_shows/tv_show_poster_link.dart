import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_rating.dart';

class TvShowPosterLink extends ConsumerWidget {
  const TvShowPosterLink({
    super.key,
    required this.show,
    this.showFavoriteButton = true,
  });

  final TvShow show;
  final bool showFavoriteButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = showFavoriteButton
        ? ref.watch(favoriteTvShowStatusProvider(show.id))
        : const AsyncValue.data(false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => context.push('/home/0/tv-show/${show.id}'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: const AssetImage(
                      'assets/loaders/wedge-loader.gif',
                    ),
                    placeholderFit: BoxFit.contain,
                    image: NetworkImage(show.posterPath),
                  ),
                ),
              ),
            ),
            if (showFavoriteButton)
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: () async {
                    await ref
                        .read(favoriteTvShowsProvider.notifier)
                        .toggleFavorite(show);
                    ref.invalidate(favoriteTvShowStatusProvider(show.id));
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
        MovieRating(voteAverage: show.voteAverage),
      ],
    );
  }
}
