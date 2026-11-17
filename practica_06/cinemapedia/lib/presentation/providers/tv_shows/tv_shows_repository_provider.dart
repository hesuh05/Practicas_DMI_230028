import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/infrastructure/datasources/tv_shows_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/tv_shows_repository_impl.dart';
import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';

final tvShowsRepositoryProvider = Provider((ref) {
  final language = ref.watch(languageProvider);
  return TvShowsRepositoryImpl(
    TvShowsMoviedbDatasource(
      language: language.tmdbLanguage,
      region: language.region,
    ),
  );
});
