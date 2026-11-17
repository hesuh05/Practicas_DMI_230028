import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';

abstract class LocalStorageRepository {
  Future<void> toggleFavorite(Movie movie);

  Future<bool> isMovieFavorite(int movieId);

  Future<List<Movie>> loadMovies({int limit = 10, int offset = 0});

  Future<void> toggleFavoriteTvShow(TvShow show);
  Future<bool> isTvShowFavorite(int showId);
  Future<List<TvShow>> loadTvShows({int limit = 10, int offset = 0});
}
