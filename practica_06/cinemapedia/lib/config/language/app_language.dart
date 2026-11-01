import 'package:flutter/material.dart';

class AppLanguage {
  final String code;
  final String name;
  final String tmdbLanguage;
  final String region;
  final Locale locale;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.tmdbLanguage,
    required this.region,
    required this.locale,
  });

  static const supported = [
    AppLanguage(
      code: 'MX',
      name: 'Español',
      tmdbLanguage: 'es-MX',
      region: 'MX',
      locale: Locale('es', 'MX'),
    ),
    AppLanguage(
      code: 'US',
      name: 'English',
      tmdbLanguage: 'en-US',
      region: 'US',
      locale: Locale('en', 'US'),
    ),
    AppLanguage(
      code: 'DE',
      name: 'Deutsch',
      tmdbLanguage: 'de-DE',
      region: 'DE',
      locale: Locale('de', 'DE'),
    ),
    AppLanguage(
      code: 'CN',
      name: '中文',
      tmdbLanguage: 'zh-CN',
      region: 'CN',
      locale: Locale('zh', 'CN'),
    ),
    AppLanguage(
      code: 'EG',
      name: 'العربية',
      tmdbLanguage: 'ar-EG',
      region: 'EG',
      locale: Locale('ar', 'EG'),
    ),
  ];

  static const defaultLanguage = AppLanguage(
    code: 'MX',
    name: 'Español',
    tmdbLanguage: 'es-MX',
    region: 'MX',
    locale: Locale('es', 'MX'),
  );
}
