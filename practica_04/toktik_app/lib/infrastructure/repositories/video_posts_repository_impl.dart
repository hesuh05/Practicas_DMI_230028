import 'dart:developer' as developer;

import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/datasources/video_post_local_store.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

class VideoPostsRepositoryImpl implements VideoPostRepository {
  VideoPostsRepositoryImpl({
    required this.videoDatasources,
    required this.localStore,
  });

  List<VideoPostDatasource> videoDatasources;
  final VideoPostLocalStore localStore;
  void Function(String message)? onFallback;
  bool _rotateDataSources = false;
  int _rotationOffset = 0;

  void setDataSources(List<VideoPostDatasource> datasources) {
    videoDatasources = datasources;
    _rotationOffset = 0;
  }

  void setRotatingDataSources(bool value) {
    _rotateDataSources = value;
    _rotationOffset = 0;
  }

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async {
    final savedPosts = await localStore.getSavedPosts();
    return savedPosts.values.where((post) => post.isLiked).toList();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) =>
      _loadWithFallback(
        page,
        (datasource) => datasource.getTrendingVideosByPage(page),
      );

  @override
  Future<List<VideoPost>> getForYouVideosByPage(int page) => _loadWithFallback(
    page,
    (datasource) => datasource.getForYouVideosByPage(page),
  );

  Future<List<VideoPost>> _loadWithFallback(
    int page,
    Future<List<VideoPost>> Function(VideoPostDatasource) load,
  ) async {
    final failures = <Object>[];
    if (videoDatasources.isEmpty) {
      throw const VideoDataSourcesException([]);
    }
    final startOffset = _rotateDataSources
        ? _rotationOffset % videoDatasources.length
        : 0;
    final orderedDatasources = List<VideoPostDatasource>.generate(
      videoDatasources.length,
      (index) =>
          videoDatasources[(startOffset + index) % videoDatasources.length],
    );
    for (var index = 0; index < orderedDatasources.length; index++) {
      final datasource = orderedDatasources[index];
      try {
        final posts = await load(datasource);
        if (posts.isNotEmpty) {
          if (_rotateDataSources) {
            _rotationOffset =
                (startOffset + index + 1) % videoDatasources.length;
          }
          if (index > 0) {
            onFallback?.call(
              '${orderedDatasources.first.runtimeType} no estuvo disponible; '
              'se usó ${datasource.runtimeType}.',
            );
          }
          return await _applySavedState(posts);
        }
        final error = StateError(
          '${datasource.runtimeType} returned no videos.',
        );
        failures.add(error);
        developer.log(
          'Video source ${datasource.runtimeType} returned no videos on '
          'page $page.',
          name: 'TokTik.VideoPostsRepository',
          error: error,
          level: 900,
        );
      } catch (error, stackTrace) {
        failures.add(error);
        developer.log(
          'Video source ${datasource.runtimeType} failed on page $page.',
          name: 'TokTik.VideoPostsRepository',
          error: error,
          stackTrace: stackTrace,
          level: 900,
        );
      }
    }
    onFallback?.call(
      '${orderedDatasources.first.runtimeType} y sus fuentes alternativas '
      'no pudieron cargar videos.',
    );
    throw VideoDataSourcesException(failures);
  }

  Future<List<VideoPost>> _applySavedState(List<VideoPost> posts) async {
    final savedPosts = await localStore.getSavedPosts();
    return posts.map((post) {
      final saved = savedPosts[post.id];
      return saved == null
          ? post
          : post.copyWith(likes: saved.likes, isLiked: saved.isLiked);
    }).toList();
  }

  @override
  Future<VideoPost> toggleLike(VideoPost video) async {
    final savedPosts = await localStore.getSavedPosts();
    final current = savedPosts[video.id] ?? video;
    final isLiked = !current.isLiked;
    final updated = current.copyWith(
      isLiked: isLiked,
      likes: (current.likes + (isLiked ? 1 : -1)).clamp(0, 0x7fffffff).toInt(),
    );
    await localStore.savePost(updated);
    return updated;
  }
}

class VideoDataSourcesException implements Exception {
  const VideoDataSourcesException(this.failures);

  final List<Object> failures;

  @override
  String toString() =>
      'All video data sources failed (${failures.length} failures): '
      '${failures.map((failure) => failure.toString()).join('; ')}';
}
