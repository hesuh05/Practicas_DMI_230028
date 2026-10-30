import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/config/theme/app_theme.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/infrastructure/datasources/local_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasources/coverr_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/pixabay_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/shared_preferences_video_store.dart';
import 'package:toktik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/season_provider.dart';
import 'package:toktik/presentation/providers/video_source_provider.dart';
import 'package:toktik/presentation/services/app_icon_service.dart';
import 'package:toktik/presentation/screens/splash_screen.dart';
import 'package:toktik/presentation/screens/video_sections_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final preferences = await SharedPreferences.getInstance().timeout(
      const Duration(seconds: 5),
    );
    final localStore = SharedPreferencesVideoStore(preferences);
    final seasonProvider = SeasonProvider(localStore: localStore);
    await seasonProvider.load().timeout(const Duration(seconds: 5));

    final client = http.Client();
    final localVideos = LocalVideoDatasource();
    final coverr = CoverrVideoDatasource(
      client: client,
      apiKey: "b6d9a1666e874fa7b83caaf084168954",
    );
    final pixabay = PixabayVideoDatasource(
      client: client,
      apiKey: "58005090-366c8ee1e16684b518c8ab417",
    );
    final discoverRepository = _createRepository([
      coverr,
      pixabay,
      localVideos,
    ], localStore);
    final forYouRepository = _createRepository([
      pixabay,
      coverr,
      localVideos,
    ], localStore);
    final favoritesRepository = _createRepository([localVideos], localStore);
    final sourceProvider = VideoSourceProvider(
      localStore: localStore,
      repositories: [discoverRepository, forYouRepository],
      sources: {
        VideoSourceMode.coverr: coverr,
        VideoSourceMode.pixabay: pixabay,
        VideoSourceMode.local: localVideos,
      },
    );
    discoverRepository.onFallback = sourceProvider.reportFallback;
    forYouRepository.onFallback = sourceProvider.reportFallback;
    await sourceProvider.load();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: seasonProvider),
          ChangeNotifierProvider.value(value: sourceProvider),
          ChangeNotifierProvider(
            lazy: false,
            create: (_) =>
                DiscoverProvider(videosRepository: discoverRepository)
                  ..loadNextPage(),
          ),
          ChangeNotifierProvider(
            lazy: false,
            create: (_) =>
                ForYouProvider(videosRepository: forYouRepository)
                  ..loadNextPage(),
          ),
          ChangeNotifierProvider(
            lazy: false,
            create: (_) =>
                FavoritesProvider(videosRepository: favoritesRepository)
                  ..loadNextPage(),
          ),
        ],
        child: const TokTikApp(),
      ),
    );
  } on Object catch (error, stackTrace) {
    debugPrint('flip could not start: $error\n$stackTrace');
    runApp(StartupErrorApp(error: error));
  }
}

VideoPostsRepositoryImpl _createRepository(
  List<VideoPostDatasource> datasources,
  SharedPreferencesVideoStore localStore,
) {
  return VideoPostsRepositoryImpl(
    videoDatasources: datasources,
    localStore: localStore,
  );
}

class TokTikApp extends StatefulWidget {
  const TokTikApp({super.key});

  @override
  State<TokTikApp> createState() => _TokTikAppState();
}

class _TokTikAppState extends State<TokTikApp> {
  bool _showSplash = true;
  AppSeason? _lastIconSeason;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final season = context.read<SeasonProvider>().season;
    if (_lastIconSeason == season) return;
    _lastIconSeason = season;
    unawaited(AppIconService.setSeason(season));
  }

  @override
  Widget build(BuildContext context) {
    final season = context.watch<SeasonProvider>().season;
    return MaterialApp(
      title: 'flip',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(season),
      home: _showSplash
          ? SplashScreen(
              season: season,
              halloweenSongChoice: context
                  .watch<SeasonProvider>()
                  .halloweenSongChoice,
              onFinished: () {
                if (mounted) setState(() => _showSplash = false);
              },
            )
          : const VideoSectionsScreen(),
    );
  }
}

class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flip',
      theme: AppTheme().getTheme(AppSeason.normal),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'flip no pudo iniciar.\n\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
