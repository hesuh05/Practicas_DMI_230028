import 'package:cinemapedia/domain/entities/entities.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<Movie> getMovieById(String id);

  Future<MediaCertification> getCertificationById(int movieId);

  Future<String?> getCertificationMeaning(
    String certification, {
    required String region,
  });

  Future<List<Movie>> searchMovies(String query);

  Future<List<Movie>> getSimilarMovies(int movieId);

  Future<List<Video>> getYoutubeVideosById(int movieId);
}
