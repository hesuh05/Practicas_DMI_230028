import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:toktik/config/theme/app_theme.dart';
import 'package:toktik/domain/datasources/video_post_local_store.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    required this.season,
    required this.halloweenSongChoice,
    required this.onFinished,
    super.key,
  });

  final AppSeason season;
  final HalloweenSongChoice halloweenSongChoice;
  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final AnimationController _logoController;
  late final Animation<double> _logoOpacity;
  Timer? _timer;
  bool _finishing = false;
  int _startGeneration = 0;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _logoOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 20),
    ]).animate(_logoController);
    _audioPlayer.audioCache = AudioCache(prefix: '');
    unawaited(_startSplash());
  }

  @override
  void didUpdateWidget(covariant SplashScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.season != widget.season ||
        oldWidget.halloweenSongChoice != widget.halloweenSongChoice) {
      unawaited(_startSplash());
    }
  }

  Future<void> _startSplash() async {
    final generation = ++_startGeneration;
    _timer?.cancel();
    _finishing = false;
    _logoController
      ..stop()
      ..reset();

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.release);
      await _audioPlayer.setVolume(0.8);
      final audioAsset = switch (widget.season) {
        AppSeason.halloween => switch (widget.halloweenSongChoice) {
          HalloweenSongChoice.original => 'lib/assets/audio/halloween.mp3',
          HalloweenSongChoice.halloweenSong =>
            'lib/assets/audio/halloween_song.mp3',
        },
        AppSeason.christmas => 'lib/assets/audio/christmas.mp3',
        AppSeason.valentines => 'lib/assets/audio/valentine.mp3',
        AppSeason.normal => null,
      };
      late final Duration duration;
      if (audioAsset == null) {
        final source = BytesSource(
          _makeWav([
            261.63,
            329.63,
            392.00,
            523.25,
            392.00,
            329.63,
            293.66,
            349.23,
            440.00,
            523.25,
            440.00,
            349.23,
          ]),
          mimeType: 'audio/wav',
        );
        await _audioPlayer.setSource(source);
        duration =
            await _audioPlayer.getDuration() ??
            const Duration(milliseconds: 3600);
      } else {
        final durationFuture = _waitForDuration(generation);
        await _audioPlayer.play(AssetSource(audioAsset));
        duration = await durationFuture ?? const Duration(seconds: 3);
      }
      if (generation != _startGeneration || !mounted) return;
      if (audioAsset == null) {
        await _audioPlayer.resume();
      }
      _logoController.duration = duration;
      unawaited(_logoController.forward());
      _timer = Timer(duration, _finish);
    } on Exception catch (error, stackTrace) {
      debugPrint('Seasonal splash audio could not play: $error\n$stackTrace');
      if (generation == _startGeneration && mounted) {
        _logoController.duration = const Duration(seconds: 3);
        unawaited(_logoController.forward());
        _timer = Timer(const Duration(seconds: 3), _finish);
      }
    }
  }

  Future<Duration?> _waitForDuration(int generation) async {
    final duration = await _audioPlayer.onDurationChanged
        .firstWhere((duration) => duration > Duration.zero)
        .timeout(const Duration(seconds: 2), onTimeout: () => Duration.zero);
    if (generation != _startGeneration) return null;
    return duration == Duration.zero ? null : duration;
  }

  String _seasonAsset(AppSeason season) => switch (season) {
    AppSeason.normal => 'lib/assets/flip_normal.png',
    AppSeason.halloween => 'lib/assets/flip_halloween.png',
    AppSeason.christmas => 'lib/assets/flip_christmas.png',
    AppSeason.valentines => 'lib/assets/flip_san_valentin.png',
  };

  void _finish() {
    if (_finishing || !mounted) return;
    _finishing = true;
    unawaited(_audioPlayer.stop());
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: _logoOpacity,
              child: Image.asset(
                _seasonAsset(widget.season),
                width: 104,
                height: 104,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Text('flip', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 20),
            const CircularProgressIndicator(strokeWidth: 2),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _logoController.dispose();
    unawaited(_audioPlayer.dispose());
    super.dispose();
  }

  Uint8List _makeWav(List<double> notes) {
    const sampleRate = 22050;
    const samplesPerNote = 6615;
    final sampleCount = samplesPerNote * notes.length;
    final bytes = Uint8List(44 + sampleCount * 2);
    final header = ByteData.sublistView(bytes);
    header
      ..setUint8(0, 0x52)
      ..setUint8(1, 0x49)
      ..setUint8(2, 0x46)
      ..setUint8(3, 0x46)
      ..setUint32(4, bytes.length - 8, Endian.little)
      ..setUint8(8, 0x57)
      ..setUint8(9, 0x41)
      ..setUint8(10, 0x56)
      ..setUint8(11, 0x45)
      ..setUint8(12, 0x66)
      ..setUint8(13, 0x6D)
      ..setUint8(14, 0x74)
      ..setUint8(15, 0x20)
      ..setUint32(16, 16, Endian.little)
      ..setUint16(20, 1, Endian.little)
      ..setUint16(22, 1, Endian.little)
      ..setUint32(24, sampleRate, Endian.little)
      ..setUint32(28, sampleRate * 2, Endian.little)
      ..setUint16(32, 2, Endian.little)
      ..setUint16(34, 16, Endian.little)
      ..setUint8(36, 0x64)
      ..setUint8(37, 0x61)
      ..setUint8(38, 0x74)
      ..setUint8(39, 0x61)
      ..setUint32(40, sampleCount * 2, Endian.little);
    for (var index = 0; index < sampleCount; index++) {
      final note = notes[index ~/ samplesPerNote];
      final notePosition = index % samplesPerNote;
      final fade = math.min(
        1.0,
        math.min(notePosition / 450, (samplesPerNote - notePosition) / 450),
      );
      final wave = math.sin(2 * math.pi * note * index / sampleRate);
      final value = (wave * fade * 10000).round();
      header.setInt16(44 + index * 2, value, Endian.little);
    }
    return bytes;
  }
}
