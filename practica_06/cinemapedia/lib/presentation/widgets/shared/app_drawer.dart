import 'package:cinemapedia/config/language/app_language.dart';
import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Text(
                'Cinemapedia',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(_settingsLabel(language)),
              onTap: () {
                Navigator.of(context).pop();
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const _LanguageSettingsSheet(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _settingsLabel(AppLanguage language) {
    switch (language.code) {
      case 'US':
        return 'Settings';
      case 'DE':
        return 'Einstellungen';
      case 'CN':
        return '设置';
      case 'EG':
        return 'الإعدادات';
      default:
        return 'Configuración';
    }
  }
}

class _LanguageSettingsSheet extends ConsumerWidget {
  const _LanguageSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(languageProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(_title(selected)),
              leading: const Icon(Icons.language),
            ),
            ...AppLanguage.supported.map(
              (language) => RadioListTile<String>(
                value: language.code,
                groupValue: selected.code,
                title: Text('${language.name} (${language.code})'),
                onChanged: (_) {
                  ref.read(languageProvider.notifier).changeLanguage(language);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _title(AppLanguage language) {
    switch (language.code) {
      case 'US':
        return 'Language';
      case 'DE':
        return 'Sprache';
      case 'CN':
        return '语言';
      case 'EG':
        return 'اللغة';
      default:
        return 'Idioma';
    }
  }
}
