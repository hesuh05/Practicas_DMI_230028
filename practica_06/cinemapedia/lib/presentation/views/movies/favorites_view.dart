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
    ref.read(favoriteTvShowsProvider.notifier).loadNextPage();
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
    final favoriteTvShows = ref.watch(favoriteTvShowsProvider).values.toList();
    final language = ref.watch(languageProvider);
    if (favoriteMovies.isEmpty && favoriteTvShows.isEmpty) {
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

    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: _label(language.code, 'movies')),
                  Tab(text: _label(language.code, 'series')),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    favoriteMovies.isEmpty
                        ? Center(
                            child: Text(_label(language.code, 'emptyMovies')),
                          )
                        : MovieMasonry(
                            movies: favoriteMovies,
                            loadNextPage: _loadNextPage,
                          ),
                    favoriteTvShows.isEmpty
                        ? Center(
                            child: Text(_label(language.code, 'emptySeries')),
                          )
                        : TvShowMasonry(shows: favoriteTvShows),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _label(String language, String key) {
    const labels = {
      'MX': {
        'emptyTitle': 'Ohhh no!!',
        'emptyBody': 'No tienes películas favoritas',
        'search': 'Empieza a buscar',
        'movies': 'Películas',
        'series': 'Series',
        'emptyMovies': 'No tienes películas favoritas',
        'emptySeries': 'No tienes series favoritas',
      },
      'US': {
        'emptyTitle': 'Ohhh no!!',
        'emptyBody': 'You have no favorite movies',
        'search': 'Start searching',
        'movies': 'Movies',
        'series': 'Series',
        'emptyMovies': 'You have no favorite movies',
        'emptySeries': 'You have no favorite series',
      },
      'DE': {
        'emptyTitle': 'Ohhh nein!!',
        'emptyBody': 'Du hast keine Lieblingsfilme',
        'search': 'Suche starten',
        'movies': 'Filme',
        'series': 'Serien',
        'emptyMovies': 'Keine Lieblingsfilme',
        'emptySeries': 'Keine Lieblingsserien',
      },
      'CN': {
        'emptyTitle': '哦不!!',
        'emptyBody': '你还没有收藏的内容',
        'search': '开始搜索',
        'movies': '电影',
        'series': '剧集',
        'emptyMovies': '还没有收藏的电影',
        'emptySeries': '还没有收藏的剧集',
      },
      'EG': {
        'emptyTitle': 'أوه لا!!',
        'emptyBody': 'لا توجد أفلام مفضلة',
        'search': 'ابدأ البحث',
        'movies': 'أفلام',
        'series': 'مسلسلات',
        'emptyMovies': 'لا توجد أفلام مفضلة',
        'emptySeries': 'لا توجد مسلسلات مفضلة',
      },
    };

    return labels[language]?[key] ?? labels['MX']![key]!;
  }
}
