import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/config/helpers/certification_meaning.dart';
import 'package:cinemapedia/domain/entities/media_certification.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class CertificationMeaningText extends ConsumerWidget {
  const CertificationMeaningText({
    super.key,
    required this.certification,
    required this.media,
  });

  final MediaCertification certification;
  final CertificationMedia media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final localMeaning = CertificationMeaning.localized(
      certification: certification.code,
      region: certification.region,
      language: language.code,
      media: media,
    );
    if (localMeaning != null) {
      return _MeaningLabel(text: localMeaning);
    }

    final remoteMeaning = media == CertificationMedia.movie
        ? ref.watch(movieCertificationMeaningProvider(certification))
        : ref.watch(tvCertificationMeaningProvider(certification));

    return remoteMeaning.when(
      loading: () => _MeaningLabel(
        text: _label(language.code, 'loading'),
        showProgress: true,
      ),
      error: (error, _) => _MeaningLabel(
        text: '${_label(language.code, 'error')} $error',
      ),
      data: (meaning) => _MeaningLabel(
        text: meaning?.trim().isNotEmpty == true
            ? meaning!.trim()
            : _label(language.code, 'unknown'),
      ),
    );
  }

  String _label(String language, String key) {
    const labels = {
      'MX': {
        'loading': 'Consultando el significado de la clasificación…',
        'error': 'No se pudo consultar la clasificación:',
        'unknown': 'No hay una descripción disponible para esta clasificación.',
      },
      'US': {
        'loading': 'Loading rating meaning…',
        'error': 'Could not load the rating meaning:',
        'unknown': 'No description is available for this rating.',
      },
      'DE': {
        'loading': 'Bedeutung der Einstufung wird geladen…',
        'error': 'Die Bedeutung der Einstufung konnte nicht geladen werden:',
        'unknown': 'Für diese Einstufung ist keine Beschreibung verfügbar.',
      },
      'CN': {
        'loading': '正在查询分级说明…',
        'error': '无法加载分级说明：',
        'unknown': '没有此分级的说明。',
      },
      'EG': {
        'loading': 'جارٍ تحميل معنى التصنيف…',
        'error': 'تعذر تحميل معنى التصنيف:',
        'unknown': 'لا يتوفر وصف لهذا التصنيف.',
      },
    };

    return labels[language]?[key] ?? labels['MX']![key]!;
  }
}

class _MeaningLabel extends StatelessWidget {
  const _MeaningLabel({required this.text, this.showProgress = false});

  final String text;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showProgress) ...[
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
            const SizedBox(width: 6),
          ] else ...[
            const Icon(Icons.info_outline, size: 14),
            const SizedBox(width: 4),
          ],
          Expanded(child: Text(text, style: textStyle)),
        ],
      ),
    );
  }
}
