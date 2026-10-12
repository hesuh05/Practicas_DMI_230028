import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:toktik/config/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    required this.season,
    required this.onFinished,
    super.key,
  });

  final AppSeason season;
  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;
  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), _finish);
    unawaited(_playSplashAudio());
  }

  Future<void> _playSplashAudio() async {
    final notes = switch (widget.season) {
      AppSeason.halloween => [
        146.83,
        174.61,
        146.83,
        233.08,
        220.00,
        174.61,
        146.83,
        174.61,
        155.56,
        233.08,
        174.61,
        116.54,
      ],
      AppSeason.christmas => [261.63, 329.63, 392.00, 523.25, 392.00, 329.63],
      AppSeason.valentines => [261.63, 293.66, 329.63, 392.00, 329.63, 293.66],
      AppSeason.normal => [261.63, 329.63, 392.00, 523.25, 392.00, 329.63],
    };
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(0.35);
      await _audioPlayer.play(
        BytesSource(_makeWav(notes), mimeType: 'audio/wav'),
      );
    } on Exception catch (error, stackTrace) {
      debugPrint('Seasonal splash audio could not play: $error\n$stackTrace');
    }
  }

  Future<void> _continue() async {
    // Chrome allows audio started from this button even when autoplay is blocked.
    _timer?.cancel();
    await _playSplashAudio();
    _timer = Timer(const Duration(seconds: 3), _finish);
  }

  void _finish() {
    if (_finishing || !mounted) return;
    _finishing = true;
    unawaited(_audioPlayer.stop());
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final icon = switch (widget.season) {
      AppSeason.halloween => Icons.nightlight_round,
      AppSeason.christmas => Icons.ac_unit,
      AppSeason.valentines => Icons.favorite,
      AppSeason.normal => Icons.play_circle_fill,
    };
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 76, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text('TokTik', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 20),
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(height: 12),
            TextButton(onPressed: _continue, child: const Text('Continuar')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
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
      final value = (wave * fade * 3800).round();
      header.setInt16(44 + index * 2, value, Endian.little);
    }
    return bytes;
  }
}
