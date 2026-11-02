import 'package:cinemapedia/config/language/app_language.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((
  ref,
) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.defaultLanguage);

  void changeLanguage(AppLanguage language) {
    if (state.code == language.code) return;
    state = language;
  }
}
