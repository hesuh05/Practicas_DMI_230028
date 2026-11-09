import 'package:cinemapedia/presentation/providers/settings/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FullScreenLoader extends ConsumerWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages(String language) {
    final messages = {
      'MX': [
        'Cargando películas',
        'Comprando palomitas de maíz',
        'Cargando populares',
        'Llamando a mi novia',
        'Ya mero...',
        'Esto está tardando más de lo esperado :(',
      ],
      'US': [
        'Loading movies',
        'Buying popcorn',
        'Loading popular movies',
        'Calling my girlfriend',
        'Almost there...',
        'This is taking longer than expected :(',
      ],
      'DE': [
        'Filme werden geladen',
        'Popcorn wird gekauft',
        'Beliebte Filme werden geladen',
        'Ich rufe meine Freundin an',
        'Fast geschafft...',
        'Das dauert länger als erwartet :(',
      ],
      'CN': [
        '正在加载电影',
        '正在买爆米花',
        '正在加载热门电影',
        '正在给女朋友打电话',
        '马上就好...',
        '加载时间比预期更长 :(',
      ],
      'EG': [
        'جارٍ تحميل الأفلام',
        'جارٍ شراء الفشار',
        'جارٍ تحميل الأفلام الشائعة',
        'أتصل بصديقتي',
        'أوشكنا على الانتهاء...',
        'يستغرق هذا وقتًا أطول من المتوقع :(',
      ],
    }[language]!;

    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final labels = _labels[language.code] ?? _labels['MX']!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(labels['pleaseWait']!),
          const SizedBox(height: 10),
          Image.asset(
            'assets/loaders/bottle-loader.gif',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10),

          StreamBuilder(
            stream: getLoadingMessages(language.code),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text(labels['loading']!);

              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }

  static const _labels = {
    'MX': {'pleaseWait': 'Espere por favor', 'loading': 'Cargando...'},
    'US': {'pleaseWait': 'Please wait', 'loading': 'Loading...'},
    'DE': {'pleaseWait': 'Bitte warten', 'loading': 'Wird geladen...'},
    'CN': {'pleaseWait': '请稍候', 'loading': '加载中...'},
    'EG': {'pleaseWait': 'انتظر من فضلك', 'loading': 'جارٍ التحميل...'},
  };
}
