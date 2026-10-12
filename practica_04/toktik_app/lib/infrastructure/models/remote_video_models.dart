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
    final playableUrl = _findPixabayPlayableUrl(videoFiles);
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

String? _findPixabayPlayableUrl(Map<String, dynamic> videos) {
  for (final quality in ['small', 'medium']) {
    final file = videos[quality];
    if (file is! Map<String, dynamic>) continue;
    final width = (file['width'] as num?)?.toInt();
    final height = (file['height'] as num?)?.toInt();
    final url = file['url'];
    if (width != null &&
        height != null &&
        width <= 1920 &&
        height <= 1920 &&
        url is String &&
        url.startsWith('https://') &&
        url.contains('.mp4')) {
      return url;
    }
  }
  return null;
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
      .map(
        (file) =>
            (url: readUrl(file), width: (file['width'] as num?)?.toInt() ?? 0),
      )
      .where(
        (candidate) =>
            candidate.url is String &&
            (candidate.url as String).startsWith('https://') &&
            (candidate.url as String).contains('.mp4'),
      )
      .toList();
  if (candidates.isEmpty) return null;

  // Avoid selecting 4K AVC files that many Android hardware decoders reject.
  final mobileCandidates = candidates.where((candidate) {
    return candidate.width == 0 || candidate.width <= 1920;
  }).toList();
  if (mobileCandidates.isEmpty) return null;
  final selected = mobileCandidates;
  selected.sort((a, b) => b.width.compareTo(a.width));
  return selected.first.url as String;
}
