import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/legacy.dart';

final favoriteMoviesProvider =
    StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final repository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository: repository);
});

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  StorageMoviesNotifier({required this.localStorageRepository}) : super({});

  final LocalStorageRepository localStorageRepository;
  int page = 0;

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(
      offset: page * 10,
      limit: 20,
    );
    page++;
    state = {
      ...state,
      for (final movie in movies) movie.id: movie,
    };
    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    await localStorageRepository.toggleFavorite(movie);
    if (state.containsKey(movie.id)) {
      final nextState = {...state}..remove(movie.id);
      state = nextState;
    } else {
      state = {...state, movie.id: movie};
    }
  }
}
