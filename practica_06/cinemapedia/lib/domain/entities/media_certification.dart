class MediaCertification {
  const MediaCertification({
    required this.code,
    required this.region,
    required this.requestedRegion,
  });

  const MediaCertification.empty({required this.requestedRegion})
    : code = '',
      region = '';

  final String code;
  final String region;
  final String requestedRegion;

  bool get isEmpty => code.isEmpty;
  bool get isNotEmpty => code.isNotEmpty;
  bool get isFallback => isNotEmpty && region != requestedRegion;

  String get label => isFallback ? '$region · $code' : code;

  @override
  bool operator ==(Object other) =>
      other is MediaCertification &&
      other.code == code &&
      other.region == region &&
      other.requestedRegion == requestedRegion;

  @override
  int get hashCode => Object.hash(code, region, requestedRegion);
}
