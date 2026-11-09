import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;
    final movies = await ref
        .read(favoriteMoviesProvider.notifier)
        .loadNextPage();
    if (!mounted) return;
    isLoading = false;
    if (movies.isEmpty) isLastPage = true;
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();
    final language = ref.watch(languageProvider);
    if (favoriteMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline, size: 60, color: colors.primary),
            Text(
              _label(language.code, 'emptyTitle'),
              style: TextStyle(fontSize: 30, color: colors.primary),
            ),
            Text(
              _label(language.code, 'emptyBody'),
              style: TextStyle(fontSize: 20, color: Colors.black45),
            ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () => context.go('/home/0'),
              child: Text(_label(language.code, 'search')),
            ),
          ],
        ),
      );
    }

    return MovieMasonry(movies: favoriteMovies, loadNextPage: _loadNextPage);
  }

  String _label(String language, String key) {
    const labels = {
      'MX': {
        'emptyTitle': 'Ohhh no!!',
        'emptyBody': 'No tienes películas favoritas',
        'search': 'Empieza a buscar',
      },
      'US': {
        'emptyTitle': 'Ohhh no!!',
        'emptyBody': 'You have no favorite movies',
        'search': 'Start searching',
      },
      'DE': {
        'emptyTitle': 'Ohhh nein!!',
        'emptyBody': 'Du hast keine Lieblingsfilme',
        'search': 'Suche starten',
      },
      'CN': {'emptyTitle': '哦不!!', 'emptyBody': '你还没有收藏的电影', 'search': '开始搜索'},
      'EG': {
        'emptyTitle': 'أوه لا!!',
        'emptyBody': 'لا توجد أفلام مفضلة',
        'search': 'ابدأ البحث',
      },
    };

    return labels[language]?[key] ?? labels['MX']![key]!;
  }
}
