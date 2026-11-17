import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/config/language/app_language.dart';

import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final language = ref.watch(languageProvider);
    final mediaType = ref.watch(mediaTypeProvider);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary),
              const SizedBox(width: 5),
              Text('Cinemapedia', style: titleStyle),
              const SizedBox(width: 4),
              Text(
                '230028',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                visualDensity: VisualDensity.compact,
                label: Text(_mediaTypeLabel(language.code, mediaType)),
                avatar: Icon(
                  mediaType == MediaType.movies
                      ? Icons.movie_outlined
                      : Icons.tv_outlined,
                  size: 16,
                ),
              ),

              const Spacer(),

              IconButton(
                onPressed: () async {
                  final searchQuery = ref.read(searchQueryProvider);

                  if (mediaType == MediaType.movies) {
                    final movie = await showSearch<Movie?>(
                      query: searchQuery,
                      context: context,
                      delegate: SearchMediaDelegate<Movie>(
                        initialItems: ref.read(searchedMoviesProvider),
                        searchFieldLabel: _searchLabel(language, mediaType),
                        searchMedia: ref
                            .read(searchedMoviesProvider.notifier)
                            .searchMoviesByQuery,
                        titleOf: (movie) => movie.title,
                        posterOf: (movie) => movie.posterPath,
                        overviewOf: (movie) => movie.overview,
                        voteAverageOf: (movie) => movie.voteAverage,
                      ),
                    );
                    if (movie != null && context.mounted) {
                      context.push('/home/0/movie/${movie.id}');
                    }
                    return;
                  }

                  final show = await showSearch<TvShow?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMediaDelegate<TvShow>(
                      initialItems: ref.read(searchedTvShowsProvider),
                      searchFieldLabel: _searchLabel(language, mediaType),
                      searchMedia: ref
                          .read(searchedTvShowsProvider.notifier)
                          .searchTvShowsByQuery,
                      titleOf: (show) => show.name,
                      posterOf: (show) => show.posterPath,
                      overviewOf: (show) => show.overview,
                      voteAverageOf: (show) => show.voteAverage,
                    ),
                  );
                  if (show != null && context.mounted) {
                    context.push('/home/0/tv-show/${show.id}');
                  }
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _searchLabel(AppLanguage language, MediaType mediaType) {
    final isTvShow = mediaType == MediaType.tvShows;
    switch (language.code) {
      case 'US':
        return isTvShow ? 'Search TV shows' : 'Search movies';
      case 'DE':
        return isTvShow ? 'Serien suchen' : 'Filme suchen';
      case 'CN':
        return isTvShow ? '搜索剧集' : '搜索电影';
      case 'EG':
        return isTvShow ? 'ابحث عن مسلسلات' : 'ابحث عن أفلام';
      default:
        return isTvShow ? 'Buscar series' : 'Buscar películas';
    }
  }

  String _mediaTypeLabel(String language, MediaType mediaType) {
    const labels = {
      'MX': {'movies': 'Películas', 'series': 'Series'},
      'US': {'movies': 'Movies', 'series': 'Series'},
      'DE': {'movies': 'Filme', 'series': 'Serien'},
      'CN': {'movies': '电影', 'series': '剧集'},
      'EG': {'movies': 'أفلام', 'series': 'مسلسلات'},
    };
    final key = mediaType == MediaType.movies ? 'movies' : 'series';
    return labels[language]?[key] ?? labels['MX']![key]!;
  }
}
