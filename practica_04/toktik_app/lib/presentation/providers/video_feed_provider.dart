import 'package:flutter/foundation.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

enum VideoFeed { discover, forYou, favorites }

class VideoFeedProvider extends ChangeNotifier {
  VideoFeedProvider({
    required this.videosRepository,
    required this.feed,
  });

  final VideoPostRepository videosRepository;
  final VideoFeed feed;

  bool initialLoading = true;
  bool loading = false;
  List<VideoPost> videos = [];
  String? errorMessage;
  int _page = 1;

  Future<void> loadNextPage() async {
    if (loading) return;
    loading = true;
    errorMessage = null;
    try {
      final loadedVideos = switch (feed) {
        VideoFeed.discover =>
          await videosRepository.getTrendingVideosByPage(_page),
        VideoFeed.forYou =>
          await videosRepository.getForYouVideosByPage(_page),
        VideoFeed.favorites =>
          await videosRepository.getFavoriteVideosByUser('local-user'),
      };
      if (feed == VideoFeed.favorites || _page == 1) {
        videos = loadedVideos;
      } else {
        videos = [...videos, ...loadedVideos];
      }
      if (feed != VideoFeed.favorites && loadedVideos.isNotEmpty) _page++;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      initialLoading = false;
      loading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(VideoPost post) async {
    try {
      final updated = await videosRepository.toggleLike(post);
      final index = videos.indexWhere((video) => video.id == post.id);
      if (index < 0) return;
      if (feed == VideoFeed.favorites && !updated.isLiked) {
        videos = [...videos]..removeAt(index);
      } else {
        videos = [...videos]..[index] = updated;
      }
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }
}
