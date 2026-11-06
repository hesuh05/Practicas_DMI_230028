import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/widgets/shared/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appDirection = Directionality.of(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        drawer: Directionality(
          textDirection: appDirection,
          child: const AppDrawer(),
        ),
        body: Directionality(
          textDirection: appDirection,
          child: const _HomeView(),
        ),
        bottomNavigationBar: Directionality(
          textDirection: appDirection,
          child: const CustomBottomNavigation(),
        ),
      ),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(languageProvider, (_, __) {
      ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
      ref.read(popularMoviesProvider.notifier).loadNextPage();
      ref.read(topRatedMoviesProvider.notifier).loadNextPage();
      ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    });

    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();

    final language = ref.watch(languageProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

    return CustomScrollView(
      slivers: [
        const Directionality(
          textDirection: TextDirection.ltr,
          child: SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                // const CustomAppbar(),

                MoviesSlideshow(movies: slideShowMovies),

                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: _label(language.code, 'nowPlaying'),
                  subTitle: _label(language.code, 'nowPlayingSubtitle'),
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                ),

                MovieHorizontalListview(
                  movies: upcomingMovies,
                  title: _label(language.code, 'upcoming'),
                  subTitle: _label(language.code, 'upcomingSubtitle'),
                  loadNextPage: () =>
                      ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                ),

                MovieHorizontalListview(
                  movies: popularMovies,
                  title: _label(language.code, 'popular'),
                  // subTitle: '',
                  loadNextPage: () =>
                      ref.read(popularMoviesProvider.notifier).loadNextPage(),
                ),

                MovieHorizontalListview(
                  movies: topRatedMovies,
                  title: _label(language.code, 'topRated'),
                  subTitle: _label(language.code, 'topRatedSubtitle'),
                  loadNextPage: () =>
                      ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                ),

                const SizedBox(height: 10),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }

  String _label(String language, String key) {
    const labels = {
      'MX': {
        'nowPlaying': 'En cines',
        'nowPlayingSubtitle': 'Lunes 20',
        'upcoming': 'Próximamente',
        'upcomingSubtitle': 'En este mes',
        'popular': 'Populares',
        'topRated': 'Mejor calificadas',
        'topRatedSubtitle': 'Desde siempre',
      },
      'US': {
        'nowPlaying': 'Now playing',
        'nowPlayingSubtitle': 'Currently in theaters',
        'upcoming': 'Upcoming',
        'upcomingSubtitle': 'This month',
        'popular': 'Popular',
        'topRated': 'Top rated',
        'topRatedSubtitle': 'All time',
      },
      'DE': {
        'nowPlaying': 'Im Kino',
        'nowPlayingSubtitle': 'Aktuell im Kino',
        'upcoming': 'Demnächst',
        'upcomingSubtitle': 'Diesen Monat',
        'popular': 'Beliebt',
        'topRated': 'Am besten bewertet',
        'topRatedSubtitle': 'Aller Zeiten',
      },
      'CN': {
        'nowPlaying': '正在上映',
        'nowPlayingSubtitle': '当前影院',
        'upcoming': '即将上映',
        'upcomingSubtitle': '本月',
        'popular': '热门',
        'topRated': '评分最高',
        'topRatedSubtitle': '一直以来',
      },
      'EG': {
        'nowPlaying': 'يعرض الآن',
        'nowPlayingSubtitle': 'في دور العرض',
        'upcoming': 'قريباً',
        'upcomingSubtitle': 'هذا الشهر',
        'popular': 'الأكثر شعبية',
        'topRated': 'الأعلى تقييماً',
        'topRatedSubtitle': 'على الإطلاق',
      },
    };

    return labels[language]?[key] ?? labels['MX']![key]!;
  }
}
