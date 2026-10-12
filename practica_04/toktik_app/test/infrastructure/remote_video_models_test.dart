import 'package:flutter_test/flutter_test.dart';
import 'package:toktik/infrastructure/models/remote_video_models.dart';

void main() {
  test('Pixabay mapper prefers a mobile-sized video over 4K', () {
    final post = PixabayVideoMapper.fromJson({
      'id': 42,
      'tags': 'test',
      'videos': {
        'large': {
          'url': 'https://cdn.example/4k.mp4',
          'width': 3840,
          'height': 2160,
        },
        'medium': {
          'url': 'https://cdn.example/hd.mp4',
          'width': 1280,
          'height': 720,
        },
        'small': {
          'url': 'https://cdn.example/sd.mp4',
          'width': 640,
          'height': 360,
        },
      },
    });

    expect(post.videoUrl, 'https://cdn.example/sd.mp4');
  });

  test('Pixabay mapper rejects a vertical video taller than 1920', () {
    expect(
      () => PixabayVideoMapper.fromJson({
        'id': 43,
        'videos': {
          'medium': {
            'url': 'https://cdn.example/vertical.mp4',
            'width': 1440,
            'height': 2560,
          },
        },
      }),
      throwsA(isA<FormatException>()),
    );
  });
}
