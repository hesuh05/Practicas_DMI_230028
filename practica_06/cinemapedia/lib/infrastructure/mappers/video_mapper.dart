import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos.dart';

class VideoMapper {
  static Video moviedbVideoToEntity(MoviedbVideoResult video) {
    return Video(
      id: video.id,
      name: video.name,
      youtubeKey: video.key,
      publishedAt: video.publishedAt,
    );
  }
}
