import 'package:toktik/domain/entities/video_post.dart';

enum HalloweenSongChoice { original, halloweenSong }

abstract class VideoPostLocalStore {
  Future<Map<String, VideoPost>> getSavedPosts();

  Future<void> savePost(VideoPost post);

  Future<SeasonPreferences> getSeasonPreferences();

  Future<void> saveSeasonPreferences(SeasonPreferences preferences);

  Future<String?> getVideoSourceMode() async => null;

  Future<void> saveVideoSourceMode(String mode) async {}
}

class SeasonPreferences {
  const SeasonPreferences({
    this.seasonOverride,
    this.forcedDate,
    this.halloweenSongChoice = HalloweenSongChoice.original,
  });

  final String? seasonOverride;
  final DateTime? forcedDate;
  final HalloweenSongChoice halloweenSongChoice;
}
