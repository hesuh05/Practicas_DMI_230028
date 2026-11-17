import 'package:flutter/material.dart';
import 'package:cinemapedia/config/language/app_language.dart';

class AppTheme {
  ThemeData getTheme(AppLanguage language) {
    const accents = {
      'MX': Color(0xFF00897B),
      'US': Color(0xFF2862F5),
      'DE': Color(0xFFD97706),
      'CN': Color(0xFFE53935),
      'EG': Color(0xFF7E57C2),
    };
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: accents[language.code] ?? accents['US'],
    );
  }
}
