import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/domain/entities/media_certification.dart';

abstract class TvShowsDatasource {
  Future<List<TvShow>> getPopular({int page = 1});
  Future<List<TvShow>> getTopRated({int page = 1});
  Future<List<TvShow>> getOnTheAir({int page = 1});
  Future<TvShow> getById(String id);
  Future<MediaCertification> getCertificationById(int tvShowId);
  Future<String?> getCertificationMeaning(
    String certification, {
    required String region,
  });
  Future<List<TvShow>> search(String query);
  Future<List<TvEpisode>> getEpisodes(String tvShowId, int seasonNumber);
}
