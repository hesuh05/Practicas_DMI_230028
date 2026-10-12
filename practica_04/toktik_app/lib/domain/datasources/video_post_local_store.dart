import 'package:toktik/domain/entities/video_post.dart';

abstract class VideoPostLocalStore {
  Future<Map<String, VideoPost>> getSavedPosts();

  Future<void> savePost(VideoPost post);

  Future<SeasonPreferences> getSeasonPreferences();

  Future<void> saveSeasonPreferences(SeasonPreferences preferences);
}

class SeasonPreferences {
  const SeasonPreferences({this.seasonOverride, this.forcedDate});

  final String? seasonOverride;
  final DateTime? forcedDate;
}
