import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl(this.datasource);

  @override
  Future<bool> isMovieFavorite(int movieId) =>
      datasource.isMovieFavorite(movieId);

  @override
  Future<List<Movie>> loadMovies({int limit = 10, int offset = 0}) =>
      datasource.loadMovies(limit: limit, offset: offset);

  @override
  Future<void> toggleFavorite(Movie movie) => datasource.toggleFavorite(movie);

  @override
  Future<void> toggleFavoriteTvShow(TvShow show) =>
      datasource.toggleFavoriteTvShow(show);

  @override
  Future<bool> isTvShowFavorite(int showId) =>
      datasource.isTvShowFavorite(showId);

  @override
  Future<List<TvShow>> loadTvShows({int limit = 10, int offset = 0}) =>
      datasource.loadTvShows(limit: limit, offset: offset);
}
