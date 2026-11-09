import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';


class CustomBottomNavigation extends ConsumerWidget {
  final int currentIndex;

  const CustomBottomNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex,
      onTap: (index) {
        context.go('/home/$index');
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_max),
          label: _label(language.code, 'home'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.label_outline),
          label: _label(language.code, 'categories'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_outline),
          label: _label(language.code, 'favorites'),
        ),
      ]
    );
  }

  String _label(String language, String key) {
    const labels = {
      'MX': {'home': 'Inicio', 'categories': 'Categorías', 'favorites': 'Favoritos'},
      'US': {'home': 'Home', 'categories': 'Categories', 'favorites': 'Favorites'},
      'DE': {'home': 'Startseite', 'categories': 'Kategorien', 'favorites': 'Favoriten'},
      'CN': {'home': '首页', 'categories': '分类', 'favorites': '收藏'},
      'EG': {'home': 'الرئيسية', 'categories': 'التصنيفات', 'favorites': 'المفضلة'},
    };

    return labels[language]?[key] ?? labels['MX']![key]!;
  }
}