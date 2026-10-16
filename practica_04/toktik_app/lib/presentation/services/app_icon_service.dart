import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:toktik/config/theme/app_theme.dart';

class AppIconService {
  const AppIconService._();

  static const _channel = MethodChannel('flip/app_icon');

  static Future<void> setSeason(AppSeason season) async {
    try {
      await _channel.invokeMethod<void>('setSeason', {'season': season.name});
    } on MissingPluginException {
      // Desktop platforms use their statically packaged application icon.
    } on PlatformException catch (error, stackTrace) {
      debugPrint('Seasonal app icon could not be updated: $error\n$stackTrace');
    }
  }
}
