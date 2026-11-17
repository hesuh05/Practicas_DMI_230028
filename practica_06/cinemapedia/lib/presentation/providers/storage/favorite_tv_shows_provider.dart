import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final favoriteTvShowStatusProvider = FutureProvider.family
    .autoDispose<bool, int>((ref, showId) {
      return ref.watch(localStorageRepositoryProvider).isTvShowFavorite(showId);
    });

final favoriteTvShowsProvider =
    StateNotifierProvider<StorageTvShowsNotifier, Map<int, TvShow>>((ref) {
      return StorageTvShowsNotifier(
        localStorageRepository: ref.watch(localStorageRepositoryProvider),
      );
    });

class StorageTvShowsNotifier extends StateNotifier<Map<int, TvShow>> {
  StorageTvShowsNotifier({required this.localStorageRepository}) : super({});

  final LocalStorageRepository localStorageRepository;
  int page = 0;

  Future<List<TvShow>> loadNextPage() async {
    final shows = await localStorageRepository.loadTvShows(
      offset: page * 10,
      limit: 20,
    );
    page++;
    state = {...state, for (final show in shows) show.id: show};
    return shows;
  }

  Future<void> toggleFavorite(TvShow show) async {
    await localStorageRepository.toggleFavoriteTvShow(show);
    if (state.containsKey(show.id)) {
      state = {...state}..remove(show.id);
    } else {
      state = {...state, show.id: show};
    }
  }
}
