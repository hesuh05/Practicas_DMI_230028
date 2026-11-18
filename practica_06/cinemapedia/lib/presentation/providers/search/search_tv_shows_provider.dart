import 'package:flutter_riverpod/legacy.dart';

import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final searchedTvShowsProvider =
    StateNotifierProvider<SearchedTvShowsNotifier, List<TvShow>>((ref) {
      final repository = ref.watch(tvShowsRepositoryProvider);
      return SearchedTvShowsNotifier(searchTvShows: repository.search);
    });

typedef SearchTvShowsCallback = Future<List<TvShow>> Function(String query);

class SearchedTvShowsNotifier extends StateNotifier<List<TvShow>> {
  SearchedTvShowsNotifier({required this.searchTvShows}) : super([]);

  final SearchTvShowsCallback searchTvShows;

  Future<List<TvShow>> searchTvShowsByQuery(String query) async {
    final shows = await searchTvShows(query);
    state = shows;
    return shows;
  }
}
