import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/media_type_provider.dart';
import 'package:cinemapedia/presentation/providers/search/search_movies_provider.dart';
import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';

class MediaTypeSelector extends ConsumerWidget {
  const MediaTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(mediaTypeProvider);
    final language = ref.watch(languageProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: SegmentedButton<MediaType>(
        segments: [
          ButtonSegment(
            value: MediaType.movies,
            label: Text(_label(language.code, 'movies')),
            icon: const Icon(Icons.movie_outlined),
          ),
          ButtonSegment(
            value: MediaType.tvShows,
            label: Text(_label(language.code, 'series')),
            icon: const Icon(Icons.tv_outlined),
          ),
        ],
        selected: {selected},
        onSelectionChanged: (selection) {
          ref.read(mediaTypeProvider.notifier).state = selection.first;
          ref.read(searchQueryProvider.notifier).state = '';
        },
      ),
    );
  }

  String _label(String language, String key) {
    const labels = {
      'MX': {'movies': 'Películas', 'series': 'Series'},
      'US': {'movies': 'Movies', 'series': 'Series'},
      'DE': {'movies': 'Filme', 'series': 'Serien'},
      'CN': {'movies': '电影', 'series': '剧集'},
      'EG': {'movies': 'أفلام', 'series': 'مسلسلات'},
    };
    return labels[language]?[key] ?? labels['MX']![key]!;
  }
}
