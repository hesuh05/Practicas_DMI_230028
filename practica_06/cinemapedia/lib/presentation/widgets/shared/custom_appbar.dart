import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
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
                onPressed: () {
                  final searchedMovies = ref.read(searchedMoviesProvider);
                  final searchQuery = ref.read(searchQueryProvider);

                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                      initialMovies: searchedMovies,
                      searchFieldLabel: _searchLabel(language),
                      searchMovies: ref
                          .read(searchedMoviesProvider.notifier)
                          .searchMoviesByQuery,
                    ),
                  ).then((movie) {
                    if (movie == null || !context.mounted) return;

                    context.push('/home/0/movie/${movie.id}');
                  });
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _searchLabel(AppLanguage language) {
    switch (language.code) {
      case 'US':
        return 'Search movies';
      case 'DE':
        return 'Filme suchen';
      case 'CN':
        return '搜索电影';
      case 'EG':
        return 'ابحث عن أفلام';
      default:
        return 'Buscar películas';
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
