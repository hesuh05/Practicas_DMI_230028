import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/tv_shows_datasource.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/tv_show_moviedb.dart';

class TvShowsMoviedbDatasource extends TvShowsDatasource {
  final String language;
  final String region;
  late final Dio dio;

  TvShowsMoviedbDatasource({required this.language, required this.region}) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        queryParameters: {'api_key': Environment.theMovieDBKey},
      ),
    );
  }

  String _formatDate(DateTime date) => date.toIso8601String().split('T').first;

  List<TvShow> _parseShows(dynamic data) {
    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((item) => TvShowMapper.fromJson(item as Map<String, dynamic>))
        .where((show) => !show.posterPath.endsWith('no-poster.jpg'))
        .toList();
  }

  Future<List<TvShow>> _discoverShows({
    required int page,
    required Map<String, dynamic> baseParams,
    Map<String, dynamic>? originFallbackParams,
  }) async {
    // 1. Intento principal: filtrar por disponibilidad en la región
    final regionalResponse = await dio.get(
      '/discover/tv',
      queryParameters: {
        'page': page,
        'language': language,
        'watch_region': region,
        'with_watch_monetization_types': 'flatrate|free|ads|rent|buy',
        ...baseParams,
      },
    );

    final regionalShows = _parseShows(regionalResponse.data);
    if (regionalShows.isNotEmpty) return regionalShows;

    // 2. Respaldo 1 (ej. CN): filtrar por país de origen de la serie
    final originResponse = await dio.get(
      '/discover/tv',
      queryParameters: {
        'page': page,
        'language': language,
        'with_origin_country': region,
        ...(originFallbackParams ?? baseParams),
      },
    );

    final originShows = _parseShows(originResponse.data);
    if (originShows.isNotEmpty) return originShows;

    // 3. Respaldo 2: catálogo global sin filtro de región para evitar bloqueo del loader
    final globalResponse = await dio.get(
      '/discover/tv',
      queryParameters: {
        'page': page,
        'language': language,
        'sort_by': baseParams['sort_by'] ?? 'popularity.desc',
      },
    );

    return _parseShows(globalResponse.data);
  }

  @override
  Future<List<TvShow>> getPopular({int page = 1}) => _discoverShows(
        page: page,
        baseParams: {'sort_by': 'popularity.desc'},
      );

  @override
  Future<List<TvShow>> getTopRated({int page = 1}) => _discoverShows(
        page: page,
        baseParams: {
          'sort_by': 'vote_average.desc',
          'vote_count.gte': 200,
        },
        originFallbackParams: {
          'sort_by': 'vote_average.desc',
          'vote_count.gte': 20,
        },
      );

  @override
  Future<List<TvShow>> getOnTheAir({int page = 1}) {
    final today = DateTime.now();
    final nextWeek = today.add(const Duration(days: 7));

    return _discoverShows(
      page: page,
      baseParams: {
        'sort_by': 'popularity.desc',
        'air_date.gte': _formatDate(today),
        'air_date.lte': _formatDate(nextWeek),
      },
    );
  }

  @override
  Future<TvShow> getById(String id) async {
    final response = await dio.get(
      '/tv/$id',
      queryParameters: {'language': language, 'append_to_response': 'videos'},
    );
    return TvShowMapper.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<TvEpisode>> getEpisodes(String tvShowId, int seasonNumber) async {
    final response = await dio.get(
      '/tv/$tvShowId/season/$seasonNumber',
      queryParameters: {'language': language},
    );
    final episodes = response.data['episodes'] as List<dynamic>? ?? [];
    return episodes
        .whereType<Map<String, dynamic>>()
        .map(TvShowMapper.episodeFromJson)
        .toList();
  }
}