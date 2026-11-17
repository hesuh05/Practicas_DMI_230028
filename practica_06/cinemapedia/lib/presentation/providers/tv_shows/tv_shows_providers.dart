import 'package:flutter_riverpod/legacy.dart';

import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/tv_shows/tv_shows_repository_provider.dart';

final popularTvShowsProvider =
    StateNotifierProvider<TvShowsNotifier, List<TvShow>>((ref) {
      return TvShowsNotifier(
        fetchMoreShows: ref.watch(tvShowsRepositoryProvider).getPopular,
      );
    });

final topRatedTvShowsProvider =
    StateNotifierProvider<TvShowsNotifier, List<TvShow>>((ref) {
      return TvShowsNotifier(
        fetchMoreShows: ref.watch(tvShowsRepositoryProvider).getTopRated,
      );
    });

final onTheAirTvShowsProvider =
    StateNotifierProvider<TvShowsNotifier, List<TvShow>>((ref) {
      return TvShowsNotifier(
        fetchMoreShows: ref.watch(tvShowsRepositoryProvider).getOnTheAir,
      );
    });

typedef TvShowsCallback = Future<List<TvShow>> Function({int page});

class TvShowsNotifier extends StateNotifier<List<TvShow>> {
  TvShowsNotifier({required this.fetchMoreShows}) : super([]);

  final TvShowsCallback fetchMoreShows;
  int currentPage = 0;
  bool isLoading = false;

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    try {
      final shows = await fetchMoreShows(page: ++currentPage);
      state = [...state, ...shows];
    } finally {
      isLoading = false;
    }
  }
}
