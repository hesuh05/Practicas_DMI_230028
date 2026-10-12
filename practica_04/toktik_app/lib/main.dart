import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/config/api/api_config.dart';
import 'package:toktik/config/theme/app_theme.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';
import 'package:toktik/infrastructure/datasources/local_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasources/pexels_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/pixabay_video_datasource.dart';
import 'package:toktik/infrastructure/datasources/shared_preferences_video_store.dart';
import 'package:toktik/infrastructure/datasources/vimeo_video_datasource.dart';
import 'package:toktik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/season_provider.dart';
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
    final pexels = PexelsVideoDatasource(
      client: client,
      apiKey: ApiConfig.pexelsApiKey,
    );
    final pixabay = PixabayVideoDatasource(
      client: client,
      apiKey: ApiConfig.pixabayApiKey,
    );
    final vimeo = VimeoVideoDatasource(
      client: client,
      accessToken: ApiConfig.vimeoAccessToken,
    );
    final discoverRepository = _createRepository([
      pexels,
      pixabay,
      vimeo,
      localVideos,
    ], localStore);
    final forYouRepository = _createRepository([
      pixabay,
      pexels,
      vimeo,
      localVideos,
    ], localStore);
    final favoritesRepository = _createRepository([localVideos], localStore);

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: seasonProvider),
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
    debugPrint('TokTik could not start: $error\n$stackTrace');
    runApp(StartupErrorApp(error: error));
  }
}

VideoPostRepository _createRepository(
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

  @override
  Widget build(BuildContext context) {
    final season = context.watch<SeasonProvider>().season;
    return MaterialApp(
      title: 'TokTik',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(season),
      home: _showSplash
          ? SplashScreen(
              season: season,
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
      title: 'TokTik',
      theme: AppTheme().getTheme(AppSeason.normal),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'TokTik no pudo iniciar.\n\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
