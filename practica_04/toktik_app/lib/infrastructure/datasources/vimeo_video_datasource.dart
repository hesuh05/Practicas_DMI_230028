import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/remote_video_models.dart';

class VimeoVideoDatasource implements VideoPostDatasource {
  const VimeoVideoDatasource({
    required this.client,
    required this.accessToken,
  });

  final http.Client client;
  final String accessToken;

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) =>
      _fetch(page, 'short video');

  @override
  Future<List<VideoPost>> getForYouVideosByPage(int page) =>
      _fetch(page, 'vertical video');

  Future<List<VideoPost>> _fetch(int page, String query) async {
    if (accessToken.isEmpty) {
      throw StateError('VIMEO_ACCESS_TOKEN has not been configured.');
    }
    final response = await client
        .get(
          Uri.https('api.vimeo.com', '/videos', {
            'query': query,
            'page': '$page',
            'per_page': '15',
            'fields': 'uri,name,files,stats',
          }),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/vnd.vimeo.*+json;version=3.4',
          },
        )
        .timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) {
      throw StateError('Vimeo returned HTTP ${response.statusCode}.');
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final videos = decoded['data'] as List<dynamic>? ?? const [];
    final mapped = <VideoPost>[];
    for (final item in videos.whereType<Map<String, dynamic>>()) {
      try {
        mapped.add(VimeoVideoMapper.fromJson(item));
      } on FormatException {
        continue;
      }
    }
    if (mapped.isEmpty) {
      throw const FormatException(
        'Vimeo returned no video files available to this token.',
      );
    }
    return mapped;
  }
}
