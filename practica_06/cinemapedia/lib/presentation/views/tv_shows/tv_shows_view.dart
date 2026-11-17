import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/tv_shows/tv_show_masonry.dart';

class TvShowsView extends ConsumerStatefulWidget {
  const TvShowsView({super.key});

  @override
  ConsumerState<TvShowsView> createState() => _TvShowsViewState();
}

class _TvShowsViewState extends ConsumerState<TvShowsView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final popular = ref.watch(popularTvShowsProvider);
    final onTheAir = ref.watch(onTheAirTvShowsProvider);
    final shows = [...popular, ...onTheAir];

    if (shows.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return TvShowMasonry(
      shows: shows,
      loadNextPage: () =>
          ref.read(popularTvShowsProvider.notifier).loadNextPage(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
