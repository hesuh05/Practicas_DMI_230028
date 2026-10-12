import 'package:toktik/domain/entities/video_post.dart';

class PexelsVideoMapper {
  const PexelsVideoMapper._();

  static VideoPost fromJson(Map<String, dynamic> json) {
    final videoFiles = json['video_files'] as List<dynamic>? ?? const [];
    final playableUrl = _findPlayableUrl(videoFiles, (file) => file['link']);
    if (playableUrl == null) {
      throw const FormatException('Pexels video has no playable MP4 file.');
    }
    final user = json['user'] as Map<String, dynamic>? ?? const {};
    return VideoPost(
      id: 'pexels-${json['id']}',
      caption: (user['name'] as String?)?.trim().isNotEmpty == true
          ? user['name'] as String
          : 'Video de Pexels',
      videoUrl: playableUrl,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
      source: 'pexels',
    );
  }
}

class PixabayVideoMapper {
  const PixabayVideoMapper._();

  static VideoPost fromJson(Map<String, dynamic> json) {
    final videoFiles = json['videos'] as Map<String, dynamic>? ?? const {};
    final playableUrl = _findPlayableUrl(
      videoFiles.values.toList(),
      (file) => file['url'],
    );
    if (playableUrl == null) {
      throw const FormatException('Pixabay video has no playable MP4 file.');
    }
    return VideoPost(
      id: 'pixabay-${json['id']}',
      caption: (json['tags'] as String?)?.trim().isNotEmpty == true
          ? json['tags'] as String
          : 'Video de Pixabay',
      videoUrl: playableUrl,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
      source: 'pixabay',
    );
  }
}

class VimeoVideoMapper {
  const VimeoVideoMapper._();

  static VideoPost fromJson(Map<String, dynamic> json) {
    final files = json['files'] as List<dynamic>? ?? const [];
    final playableUrl = _findPlayableUrl(files, (file) {
      return file['link_secure'] ?? file['link'];
    });
    if (playableUrl == null) {
      throw const FormatException(
        'Vimeo did not return a playable file for this video.',
      );
    }
    return VideoPost(
      id: 'vimeo-${json['uri'] ?? json['id']}',
      caption: (json['name'] as String?)?.trim().isNotEmpty == true
          ? json['name'] as String
          : 'Video de Vimeo',
      videoUrl: playableUrl,
      likes: 0,
      views:
          ((json['stats'] as Map<String, dynamic>?)?['plays'] as num?)
              ?.toInt() ??
          0,
      source: 'vimeo',
    );
  }
}

String? _findPlayableUrl(
  List<dynamic> files,
  Object? Function(Map<String, dynamic>) readUrl,
) {
  final candidates = files
      .whereType<Map<String, dynamic>>()
      .map((file) => readUrl(file))
      .whereType<String>()
      .where((url) => url.startsWith('https://') && url.contains('.mp4'))
      .toList();
  return candidates.isEmpty ? null : candidates.first;
}
