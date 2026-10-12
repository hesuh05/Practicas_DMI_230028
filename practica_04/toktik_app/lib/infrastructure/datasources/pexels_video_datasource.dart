import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/remote_video_models.dart';

class PexelsVideoDatasource implements VideoPostDatasource {
  const PexelsVideoDatasource({
    required this.client,
    required this.apiKey,
  });

  final http.Client client;
  final String apiKey;

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) =>
      _fetch(page, 'popular');

  @override
  Future<List<VideoPost>> getForYouVideosByPage(int page) =>
      _fetch(page, 'popular');

  Future<List<VideoPost>> _fetch(int page, String endpoint) async {
    if (apiKey.isEmpty) {
      throw StateError('PEXELS_API_KEY has not been configured.');
    }
    final response = await client
        .get(
          Uri.https('api.pexels.com', '/videos/$endpoint', {
            'page': '$page',
            'per_page': '15',
          }),
          headers: {'Authorization': apiKey},
        )
        .timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) {
      throw StateError('Pexels returned HTTP ${response.statusCode}.');
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final videos = decoded['videos'] as List<dynamic>? ?? const [];
    final mapped = <VideoPost>[];
    for (final item in videos.whereType<Map<String, dynamic>>()) {
      try {
        mapped.add(PexelsVideoMapper.fromJson(item));
      } on FormatException {
        continue;
      }
    }
    if (mapped.isEmpty) {
      throw const FormatException('Pexels returned no playable videos.');
    }
    return mapped;
  }
}
