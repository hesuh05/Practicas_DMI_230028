import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/config/helpers/certification_meaning.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

final tvShowByIdProvider = FutureProvider.family.autoDispose((ref, String id) {
  return ref.watch(tvShowsRepositoryProvider).getById(id);
});

class TvShowScreen extends ConsumerWidget {
  static const name = 'tv-show-screen';

  const TvShowScreen({super.key, required this.tvShowId});

  final String tvShowId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final show = ref.watch(tvShowByIdProvider(tvShowId));
    final showId = int.tryParse(tvShowId);
    final isFavorite = showId == null
        ? const AsyncValue.data(false)
        : ref.watch(favoriteTvShowStatusProvider(showId));
    ref.listen(tvShowByIdProvider(tvShowId), (_, next) {
      next.whenData(
        (_) => ref.read(actorsByTvShowProvider.notifier).loadActors(tvShowId),
      );
    });
    return Scaffold(
      body: show.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (show) => CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            _TvShowSliverAppBar(
              show: show,
              showId: showId,
              isFavorite: isFavorite,
              onToggleFavorite: () async {
                await ref
                    .read(favoriteTvShowsProvider.notifier)
                    .toggleFavorite(show);
                if (showId != null) {
                  ref.invalidate(favoriteTvShowStatusProvider(showId));
                }
              },
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _TvShowDetails(show: show, tvShowId: tvShowId),
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TvShowDetails extends StatelessWidget {
  const _TvShowDetails({required this.show, required this.tvShowId});

  final TvShow show;
  final String tvShowId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(show.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              MovieRating(voteAverage: show.voteAverage),
              if (show.certification.isNotEmpty) ...[
                const SizedBox(width: 8),
                CertificationBadge(certification: show.certification.label),
              ],
            ],
          ),
          if (show.certification.isNotEmpty)
            CertificationMeaningText(
              certification: show.certification,
              media: CertificationMedia.tv,
            ),
          const SizedBox(height: 8),
          Text(
            '${show.numberOfSeasons} temporadas · '
            '${show.numberOfEpisodes} episodios',
          ),
          const SizedBox(height: 8),
          Text(
            show.overview.isEmpty
                ? 'Sin descripción disponible.'
                : show.overview,
          ),
          const SizedBox(height: 24),
          ActorsByTvShow(tvShowId: tvShowId),
          const SizedBox(height: 24),
          TvShowSeasons(tvShowId: tvShowId, seasons: show.seasons),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class _TvShowSliverAppBar extends StatelessWidget {
  const _TvShowSliverAppBar({
    required this.show,
    required this.showId,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final TvShow show;
  final int? showId;
  final AsyncValue<bool> isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SliverAppBar(
        backgroundColor: Colors.black,
        expandedHeight: size.height * 0.7,
        foregroundColor: Colors.white,
        leading: const BackButton(),
        actions: [
          if (showId != null)
            IconButton(
              onPressed: onToggleFavorite,
              icon: isFavorite.when(
                loading: () => const CircularProgressIndicator(strokeWidth: 2),
                data: (favorite) => Icon(
                  favorite ? Icons.favorite_rounded : Icons.favorite_border,
                  color: favorite ? Colors.red : null,
                ),
                error: (_, _) => const Icon(Icons.error_outline),
              ),
            ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          background: Stack(
            children: [
              SizedBox.expand(
                child: Image.network(
                  show.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) return const SizedBox();
                    return FadeIn(child: child);
                  },
                ),
              ),
              const SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.7, 1.0],
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
              ),
              const SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      stops: [0.0, 0.3],
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
