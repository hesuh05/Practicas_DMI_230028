import 'package:cinemapedia/domain/datasources/tv_shows_datasource.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/domain/repositories/tv_shows_repository.dart';

class TvShowsRepositoryImpl extends TvShowsRepository {
  final TvShowsDatasource datasource;

  TvShowsRepositoryImpl(this.datasource);

  @override
  Future<List<TvShow>> getPopular({int page = 1}) =>
      datasource.getPopular(page: page);

  @override
  Future<List<TvShow>> getTopRated({int page = 1}) =>
      datasource.getTopRated(page: page);

  @override
  Future<List<TvShow>> getOnTheAir({int page = 1}) =>
      datasource.getOnTheAir(page: page);

  @override
  Future<TvShow> getById(String id) => datasource.getById(id);

  @override
  Future<List<TvEpisode>> getEpisodes(String tvShowId, int seasonNumber) =>
      datasource.getEpisodes(tvShowId, seasonNumber);
}
