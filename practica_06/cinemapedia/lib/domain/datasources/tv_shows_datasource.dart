import 'package:cinemapedia/domain/entities/tv_show.dart';

abstract class TvShowsDatasource {
  Future<List<TvShow>> getPopular({int page = 1});
  Future<List<TvShow>> getTopRated({int page = 1});
  Future<List<TvShow>> getOnTheAir({int page = 1});
  Future<TvShow> getById(String id);
  Future<List<TvEpisode>> getEpisodes(String tvShowId, int seasonNumber);
}
