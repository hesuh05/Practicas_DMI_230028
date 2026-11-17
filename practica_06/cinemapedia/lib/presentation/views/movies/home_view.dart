import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(popularTvShowsProvider.notifier).loadNextPage();
    ref.read(onTheAirTvShowsProvider.notifier).loadNextPage();
    ref.read(topRatedTvShowsProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(languageProvider, (_, _) {
      ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
      ref.read(popularMoviesProvider.notifier).loadNextPage();
      ref.read(topRatedMoviesProvider.notifier).loadNextPage();
      ref.read(upcomingMoviesProvider.notifier).loadNextPage();
      ref.read(popularTvShowsProvider.notifier).loadNextPage();
      ref.read(onTheAirTvShowsProvider.notifier).loadNextPage();
      ref.read(topRatedTvShowsProvider.notifier).loadNextPage();
    });

    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();
    final mediaType = ref.watch(mediaTypeProvider);

    final language = ref.watch(languageProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final popularTvShows = ref.watch(popularTvShowsProvider);
    final onTheAirTvShows = ref.watch(onTheAirTvShowsProvider);
    final topRatedTvShows = ref.watch(topRatedTvShowsProvider);

    return CustomScrollView(
      slivers: [
        const Directionality(
          textDirection: TextDirection.ltr,
          child: SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
          ),
        ),
        if (mediaType == MediaType.tvShows)
          SliverList(
            delegate: SliverChildListDelegate([
              TvShowsSlideshow(shows: onTheAirTvShows),
              TvShowHorizontalListView(
                shows: onTheAirTvShows,
                title: _label(language.code, 'onTheAir'),
                subTitle: _label(language.code, 'onTheAirSubtitle'),
                loadNextPage: () =>
                    ref.read(onTheAirTvShowsProvider.notifier).loadNextPage(),
              ),
              TvShowHorizontalListView(
                shows: popularTvShows,
                title: _label(language.code, 'popular'),
                loadNextPage: () =>
                    ref.read(popularTvShowsProvider.notifier).loadNextPage(),
              ),
              TvShowHorizontalListView(
                shows: topRatedTvShows,
                title: _label(language.code, 'topRated'),
                subTitle: _label(language.code, 'topRatedSubtitle'),
                loadNextPage: () =>
                    ref.read(topRatedTvShowsProvider.notifier).loadNextPage(),
              ),
              const SizedBox(height: 10),
            ]),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Column(
                children: [
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
                    loadNextPage: () => ref
                        .read(upcomingMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  MovieHorizontalListview(
                    movies: popularMovies,
                    title: _label(language.code, 'popular'),
                    loadNextPage: () =>
                        ref.read(popularMoviesProvider.notifier).loadNextPage(),
                  ),
                  MovieHorizontalListview(
                    movies: topRatedMovies,
                    title: _label(language.code, 'topRated'),
                    subTitle: _label(language.code, 'topRatedSubtitle'),
                    loadNextPage: () => ref
                        .read(topRatedMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              childCount: 1,
            ),
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
        'onTheAir': 'En emisión',
        'onTheAirSubtitle': 'Esta semana',
      },
      'US': {
        'nowPlaying': 'Now playing',
        'nowPlayingSubtitle': 'Currently in theaters',
        'upcoming': 'Upcoming',
        'upcomingSubtitle': 'This month',
        'popular': 'Popular',
        'topRated': 'Top rated',
        'topRatedSubtitle': 'All time',
        'onTheAir': 'On the air',
        'onTheAirSubtitle': 'This week',
      },
      'DE': {
        'nowPlaying': 'Im Kino',
        'nowPlayingSubtitle': 'Aktuell im Kino',
        'upcoming': 'Demnächst',
        'upcomingSubtitle': 'Diesen Monat',
        'popular': 'Beliebt',
        'topRated': 'Am besten bewertet',
        'topRatedSubtitle': 'Aller Zeiten',
        'onTheAir': 'Im Fernsehen',
        'onTheAirSubtitle': 'Diese Woche',
      },
      'CN': {
        'nowPlaying': '正在上映',
        'nowPlayingSubtitle': '当前影院',
        'upcoming': '即将上映',
        'upcomingSubtitle': '本月',
        'popular': '热门',
        'topRated': '评分最高',
        'topRatedSubtitle': '一直以来',
        'onTheAir': '正在播出',
        'onTheAirSubtitle': '本周',
      },
      'EG': {
        'nowPlaying': 'يعرض الآن',
        'nowPlayingSubtitle': 'في دور العرض',
        'upcoming': 'قريباً',
        'upcomingSubtitle': 'هذا الشهر',
        'popular': 'الأكثر شعبية',
        'topRated': 'الأعلى تقييماً',
        'topRatedSubtitle': 'على الإطلاق',
        'onTheAir': 'يعرض حالياً',
        'onTheAirSubtitle': 'هذا الأسبوع',
      },
    };

    return labels[language]?[key] ?? labels['MX']![key]!;
  }
}