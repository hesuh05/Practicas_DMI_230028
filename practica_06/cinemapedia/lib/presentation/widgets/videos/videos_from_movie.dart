import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final videosFromMovieProvider = FutureProvider.family<List<Video>, int>(
  (ref, movieId) =>
      ref.watch(movieRepositoryProvider).getYoutubeVideosById(movieId),
);

class VideosFromMovie extends ConsumerWidget {
  const VideosFromMovie({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videos = ref.watch(videosFromMovieProvider(movieId));
    return videos.when(
      data: (items) => items.isEmpty
          ? const SizedBox.shrink()
          : _VideoPlayer(video: items.first),
      error: (_, _) => const SizedBox.shrink(),
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  const _VideoPlayer({required this.video});

  final Video video;

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late final YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController.fromVideoId(
      videoId: widget.video.youtubeKey,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        showVideoAnnotations: false,
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Videos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(widget.video.name),
          YoutubePlayer(controller: controller),
        ],
      ),
    );
  }
}
