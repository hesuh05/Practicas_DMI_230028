enum CertificationMedia { movie, tv }

class CertificationMeaning {
  static String? localized({
    required String certification,
    required String region,
    required String language,
    required CertificationMedia media,
  }) {
    final code = certification.trim().toUpperCase();
    final normalizedCode = code.replaceAll(RegExp(r'[\s-]+'), '');

    if (region == 'DE') {
      final fskAge = _fskAge(code);
      if (fskAge != null) return _ageLimit(language, fskAge);
    }

    switch (code) {
      case 'AA':
        return _text(
          language,
          es: 'Contenido dirigido al público infantil, especialmente '
              'menores de 7 años.',
          en: 'Content intended for children, especially viewers under 7.',
          de: 'Inhalt für Kinder, besonders für Zuschauer unter 7 Jahren.',
          zh: '适合儿童，尤其是7岁以下观众。',
          ar: 'محتوى مخصص للأطفال، وخاصة من هم دون 7 سنوات.',
        );
      case 'A':
        return _text(
          language,
          es: 'Apta para todo público.',
          en: 'Suitable for all audiences.',
          de: 'Für alle Altersgruppen geeignet.',
          zh: '适合所有观众。',
          ar: 'مناسب لجميع الأعمار.',
        );
      case 'B':
        return _ageLimit(language, 12);
      case 'B15':
      case 'B-15':
        return _underAge(language, 15);
      case 'C':
        return _ageLimit(language, 18);
      case 'D':
        return _text(
          language,
          es: 'Contenido extremo, exclusivo para adultos.',
          en: 'Extreme content, exclusively for adults.',
          de: 'Extremer Inhalt, ausschließlich für Erwachsene.',
          zh: '极端内容，仅限成年人。',
          ar: 'محتوى شديد، مخصص للبالغين فقط.',
        );
    }

    if (media == CertificationMedia.tv) {
      switch (code) {
        case 'TV-Y':
          return _text(
            language,
            es: 'Diseñada para niños de todas las edades.',
            en: 'Designed for children of all ages.',
            de: 'Für Kinder jeden Alters geeignet.',
            zh: '适合所有年龄段的儿童。',
            ar: 'مخصص للأطفال من جميع الأعمار.',
          );
        case 'TV-Y7':
          return _ageLimit(language, 7);
        case 'TV-G':
          return _text(
            language,
            es: 'Apta para todo público.',
            en: 'Suitable for all audiences.',
            de: 'Für alle Altersgruppen geeignet.',
            zh: '适合所有观众。',
            ar: 'مناسب لجميع الأعمار.',
          );
        case 'TV-PG':
          return _text(
            language,
            es: 'Se recomienda la orientación de madres, padres o tutores.',
            en: 'Parental guidance is suggested.',
            de: 'Elterliche Begleitung wird empfohlen.',
            zh: '建议家长指导观看。',
            ar: 'يوصى بتوجيه الوالدين.',
          );
        case 'TV-14':
          return _underAge(language, 14);
        case 'TV-MA':
          return _text(
            language,
            es: 'Dirigida a público adulto; puede no ser adecuada para '
                'menores de 17 años.',
            en: 'Intended for mature audiences; may be unsuitable for viewers '
                'under 17.',
            de: 'Für ein erwachsenes Publikum; möglicherweise ungeeignet für '
                'Zuschauer unter 17 Jahren.',
            zh: '适合成年观众，可能不适合17岁以下观众。',
            ar: 'مخصص للبالغين، وقد لا يناسب من هم دون 17 عامًا.',
          );
      }
    } else {
      switch (code) {
        case 'G':
          return _text(
            language,
            es: 'Apta para todo público.',
            en: 'Suitable for all audiences.',
            de: 'Für alle Altersgruppen geeignet.',
            zh: '适合所有观众。',
            ar: 'مناسب لجميع الأعمار.',
          );
        case 'PG':
          return _text(
            language,
            es: 'Se recomienda la orientación de madres, padres o tutores.',
            en: 'Parental guidance is suggested.',
            de: 'Elterliche Begleitung wird empfohlen.',
            zh: '建议家长指导观看。',
            ar: 'يوصى بتوجيه الوالدين.',
          );
        case 'PG-13':
          return _text(
            language,
            es: 'Se recomienda cautela: algunos contenidos pueden no ser '
                'apropiados para menores de 13 años.',
            en: 'Parents are strongly cautioned; some material may be '
                'inappropriate for children under 13.',
            de: 'Eltern wird besondere Vorsicht empfohlen; manche Inhalte '
                'können für Kinder unter 13 Jahren ungeeignet sein.',
            zh: '建议家长谨慎选择；部分内容可能不适合13岁以下儿童。',
            ar: 'ينبغي على الوالدين توخي الحذر؛ فقد لا يناسب بعض المحتوى من '
                'هم دون 13 عامًا.',
          );
        case 'R':
          return _text(
            language,
            es: 'Menores de 17 años deben ir acompañados por una persona '
                'adulta.',
            en: 'Viewers under 17 must be accompanied by a parent or adult.',
            de: 'Zuschauer unter 17 Jahren müssen von einem Erwachsenen '
                'begleitet werden.',
            zh: '17岁以下观众须由家长或成年人陪同。',
            ar: 'يجب أن يرافق من هم دون 17 عامًا أحد الوالدين أو شخص بالغ.',
          );
        case 'NC-17':
          return _text(
            language,
            es: 'No se permite la entrada a menores de 17 años.',
            en: 'No one 17 and under is admitted.',
            de: 'Kein Zutritt für Personen unter 18 Jahren.',
            zh: '17岁及以下观众不得观看。',
            ar: 'لا يسمح بدخول من هم دون 18 عامًا.',
          );
      }
    }

    final age = _numericAge(normalizedCode);
    if (age != null) return _ageLimit(language, age);
    return null;
  }

  static int? _fskAge(String code) {
    final match = RegExp(r'^(?:FSK[\s-]*)?(\d{1,2})$').firstMatch(code);
    return match == null ? null : int.tryParse(match.group(1)!);
  }

  static int? _numericAge(String code) {
    final match = RegExp(r'^(?:TV-)?(\d{1,2})\+?$').firstMatch(code);
    return match == null ? null : int.tryParse(match.group(1)!);
  }

  static String _ageLimit(String language, int age) => _text(
    language,
    es: 'Recomendada para personas de $age años en adelante.',
    en: 'Recommended for viewers aged $age and over.',
    de: 'Empfohlen für Zuschauer ab $age Jahren.',
    zh: '建议$age岁及以上观众观看。',
    ar: 'موصى به لمن تبلغ أعمارهم $age عامًا فأكثر.',
  );

  static String _underAge(String language, int age) => _text(
    language,
    es: 'No recomendada para menores de $age años.',
    en: 'Not recommended for viewers under $age.',
    de: 'Nicht für Zuschauer unter $age Jahren empfohlen.',
    zh: '不建议$age岁以下观众观看。',
    ar: 'غير موصى به لمن هم دون $age عامًا.',
  );

  static String _text(
    String language, {
    required String es,
    required String en,
    required String de,
    required String zh,
    required String ar,
  }) {
    switch (language) {
      case 'US':
        return en;
      case 'DE':
        return de;
      case 'CN':
        return zh;
      case 'EG':
        return ar;
      default:
        return es;
    }
  }
}
