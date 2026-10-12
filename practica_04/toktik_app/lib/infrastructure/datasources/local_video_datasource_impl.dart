import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';
import 'package:toktik/shared/data/local_video_posts.dart';

class LocalVideoDatasource implements VideoPostDatasource {
  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    final availableVideos = <VideoPost>[];
    for (final video in videoPosts) {
      final path = video['videoUrl'] as String;
      try {
        await rootBundle.load(path);
        availableVideos.add(
          LocalVideoModel.fromJson(video).toVideoPostEntity(),
        );
      } on FlutterError {
        // The local fallback is optional; skip files not bundled by the app.
      }
    }
    return availableVideos;
  }

  @override
  Future<List<VideoPost>> getForYouVideosByPage(int page) =>
      getTrendingVideosByPage(page);
}
