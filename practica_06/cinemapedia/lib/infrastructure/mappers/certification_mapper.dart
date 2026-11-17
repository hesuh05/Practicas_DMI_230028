class CertificationMapper {
  static String? meaningForRegion(
    dynamic data, {
    required String region,
    required String certification,
  }) {
    if (data is! Map<String, dynamic>) return null;
    final certifications = data['certifications'];
    if (certifications is! Map<String, dynamic>) return null;
    final regionalCertifications = certifications[region];
    if (regionalCertifications is! List) return null;

    final expectedCode = certification.trim().toUpperCase();
    for (final item in regionalCertifications) {
      if (item is! Map<String, dynamic>) continue;
      final code = item['certification']?.toString().trim().toUpperCase();
      if (code != expectedCode) continue;

      final meaning = item['meaning']?.toString().trim() ?? '';
      return meaning.isEmpty ? null : meaning;
    }
    return null;
  }
}
