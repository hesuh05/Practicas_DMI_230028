import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';

class VideoPlaybackControls {
  final muted = ValueNotifier<bool>(false);
  final playing = ValueNotifier<bool>(false);
  final audioAvailable = ValueNotifier<bool?>(null);
  Future<void> Function()? _toggleMute;
  Future<void> Function()? _togglePlayback;

  Future<void> toggleMute() async => _toggleMute?.call();

  Future<void> togglePlayback() async => _togglePlayback?.call();

  void dispose() {
    muted.dispose();
    playing.dispose();
    audioAvailable.dispose();
    _toggleMute = null;
    _togglePlayback = null;
  }
}

class FullscreenPlayer extends StatefulWidget {
  const FullscreenPlayer({
    required this.video,
    required this.controls,
    required this.shouldPlay,
    super.key,
  });

  final VideoPost video;
  final VideoPlaybackControls controls;
  final bool shouldPlay;

  @override
  State<FullscreenPlayer> createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  late final VideoPlayerController _controller;
  late final Future<void> _initializeVideo;

  @override
  void initState() {
    super.initState();
    _controller = widget.video.videoUrl.startsWith('assets/')
        ? VideoPlayerController.asset(widget.video.videoUrl)
        : VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl));
    _controller.addListener(_syncControls);
    widget.controls._toggleMute = _toggleMute;
    widget.controls._togglePlayback = _togglePlayback;
    _initializeVideo = _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initialize();
    await _detectAudioTrack();
    await _controller.setLooping(true);
    await _controller.setVolume(widget.controls.muted.value ? 0 : 1);
    if (widget.shouldPlay) {
      await _controller.play();
    }
  }

  Future<void> _detectAudioTrack() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      widget.controls.audioAvailable.value = true;
      return;
    }
    try {
      final hasAudio = await const MethodChannel('toktik/audio')
          .invokeMethod<bool>('hasAudioTrack', {'url': widget.video.videoUrl});
      widget.controls.audioAvailable.value = hasAudio ?? true;
    } on MissingPluginException {
      widget.controls.audioAvailable.value = true;
    } on PlatformException catch (error) {
      debugPrint('Could not detect video audio track: $error');
      widget.controls.audioAvailable.value = true;
    }
  }

  void _syncControls() {
    if (!_controller.value.isInitialized) return;
    widget.controls.muted.value = _controller.value.volume == 0;
    widget.controls.playing.value = _controller.value.isPlaying;
  }

  @override
  void didUpdateWidget(covariant FullscreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shouldPlay == widget.shouldPlay ||
        !_controller.value.isInitialized) {
      return;
    }
    if (widget.shouldPlay) {
      _controller.play();
    } else {
      _controller.pause();
    }
  }

  Future<void> _toggleMute() async {
    if (!_controller.value.isInitialized ||
        widget.controls.audioAvailable.value == false) {
      return;
    }
    final isMuted = _controller.value.volume == 0;
    await _controller.setVolume(isMuted ? 1 : 0);
    widget.controls.muted.value = !isMuted;
  }

  Future<void> _togglePlayback() async {
    if (!_controller.value.isInitialized) return;
    if (_controller.value.isPlaying) {
      await _controller.pause();
    } else {
      await _controller.play();
    }
    widget.controls.playing.value = _controller.value.isPlaying;
  }

  @override
  void dispose() {
    _controller.removeListener(_syncControls);
    if (widget.controls._toggleMute == _toggleMute) {
      widget.controls._toggleMute = null;
      widget.controls._togglePlayback = null;
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeVideo,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'No se pudo reproducir este video de ${widget.video.source}.\n'
              '${snapshot.error}',
              textAlign: TextAlign.center,
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        return GestureDetector(
          onTap: _togglePlayback,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              VideoBackground(
                colors: [Colors.transparent, Colors.black87],
                stops: [0.48, 1],
              ),
              ValueListenableBuilder<bool>(
                valueListenable: widget.controls.playing,
                builder: (context, isPlaying, _) => isPlaying
                    ? const SizedBox.shrink()
                    : Center(
                        child: IconButton.filledTonal(
                          tooltip: 'Reproducir',
                          onPressed: _togglePlayback,
                          iconSize: 52,
                          icon: const Icon(Icons.play_arrow),
                        ),
                      ),
              ),
              Positioned(
                bottom: 24,
                left: 20,
                right: 88,
                child: _VideoCaption(caption: widget.video.caption),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VideoCaption extends StatefulWidget {
  const _VideoCaption({required this.caption});

  final String caption;

  @override
  State<_VideoCaption> createState() => _VideoCaptionState();
}

class _VideoCaptionState extends State<_VideoCaption> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: Colors.white,
      shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.caption, style: style),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          maxLines: 2,
        )..layout(maxWidth: constraints.maxWidth);
        final isLong = textPainter.didExceedMaxLines;
        textPainter.dispose();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_expanded)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 170),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Text(widget.caption, style: style),
                ),
              )
            else
              Text(
                widget.caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: style,
              ),
            if (isLong)
              TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  alignment: Alignment.centerLeft,
                ),
                child: Text(_expanded ? 'menos' : '... más'),
              ),
          ],
        );
      },
    );
  }
}
