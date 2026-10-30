import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/infrastructure/datasources/shared_preferences_video_store.dart';
import 'package:toktik/infrastructure/repositories/video_posts_repository_impl.dart';

enum VideoSourceFeed { discover, forYou }

enum VideoSourceMode {
  random,
  rotating,
  coverr,
  pixabay,
  local,
}

extension VideoSourceModeLabel on VideoSourceMode {
  String get label => switch (this) {
    VideoSourceMode.random => 'Aleatorio',
    VideoSourceMode.rotating => 'Rotatorio',
    VideoSourceMode.coverr => 'Coverr',
    VideoSourceMode.pixabay => 'Pixabay',
    VideoSourceMode.local => 'Local',
  };
}

class VideoSourceProvider extends ChangeNotifier {
  VideoSourceProvider({
    required this.localStore,
    required this.repositories,
    required this.sources,
  });

  final SharedPreferencesVideoStore localStore;
  final List<VideoPostsRepositoryImpl> repositories;
  final Map<VideoSourceMode, VideoPostDatasource> sources;
  final Map<VideoSourceFeed, VideoSourceMode> _modes = {
    VideoSourceFeed.discover: VideoSourceMode.random,
    VideoSourceFeed.forYou: VideoSourceMode.random,
  };
  String? _notice;

  VideoSourceMode modeFor(VideoSourceFeed feed) => _modes[feed]!;
  String? get notice => _notice;

  Future<void> load() async {
    for (final feed in VideoSourceFeed.values) {
      final saved = await localStore.getVideoSourceModeForFeed(feed.name);
      final legacy = saved == null
          ? await localStore.getVideoSourceMode()
          : null;
      _modes[feed] = _parseMode(saved ?? legacy);
    }
    _applyOrder();
  }

  Future<void> select(VideoSourceFeed feed, VideoSourceMode mode) async {
    await localStore.saveVideoSourceModeForFeed(feed.name, mode.name);
    _modes[feed] = mode;
    _applyOrder();
    notifyListeners();
  }

  void clearNotice() {
    _notice = null;
    notifyListeners();
  }

  void reportFallback(String message) {
    _notice = message;
    notifyListeners();
  }

  void _applyOrder() {
    for (var index = 0; index < repositories.length; index++) {
      final repository = repositories[index];
      final mode = _modes[VideoSourceFeed.values[index]]!;
      final orderedModes = <VideoSourceMode>[
        if (mode != VideoSourceMode.random && mode != VideoSourceMode.rotating)
          mode,
        ...VideoSourceMode.values.where(
          (mode) =>
              mode != VideoSourceMode.random &&
              mode != VideoSourceMode.rotating &&
              mode != _modes[VideoSourceFeed.values[index]],
        ),
      ]..shuffle(Random());
      if (mode != VideoSourceMode.random && mode != VideoSourceMode.rotating) {
        orderedModes.remove(mode);
        orderedModes.insert(0, mode);
      }
      final orderedSources = <VideoPostDatasource>[];
      for (final mode in orderedModes) {
        final source = sources[mode];
        if (source != null) orderedSources.add(source);
      }
      repository.setDataSources(orderedSources);
      repository.setRotatingDataSources(mode == VideoSourceMode.rotating);
    }
  }

  VideoSourceMode _parseMode(String? value) =>
      VideoSourceMode.values.firstWhere(
        (mode) => mode.name == value,
        orElse: () => VideoSourceMode.random,
      );
}
