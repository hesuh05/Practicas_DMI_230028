import 'package:cinemapedia/config/language/app_language.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((
  ref,
) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<AppLanguage> {
  static const _languageKey = 'selected_language';

  LanguageNotifier() : super(AppLanguage.defaultLanguage);

  Future<void> loadSavedLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    final savedCode = preferences.getString(_languageKey);
    if (savedCode == null) return;

    final savedLanguage = AppLanguage.fromCode(savedCode);
    if (savedLanguage != null) state = savedLanguage;
  }

  Future<void> changeLanguage(AppLanguage language) async {
    if (state.code == language.code) return;

    final preferences = await SharedPreferences.getInstance();
    final persisted = await preferences.setString(_languageKey, language.code);
    if (!persisted) {
      throw StateError('No se pudo guardar el idioma seleccionado.');
    }

    state = language;
  }
}
