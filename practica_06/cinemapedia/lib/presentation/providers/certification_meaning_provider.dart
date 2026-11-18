import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/media_certification.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/tv_shows/tv_shows_repository_provider.dart';

final movieCertificationMeaningProvider =
    FutureProvider.autoDispose.family<String?, MediaCertification>((
      ref,
      certification,
    ) {
      return ref.watch(movieRepositoryProvider).getCertificationMeaning(
        certification.code,
        region: certification.region,
      );
    });

final tvCertificationMeaningProvider =
    FutureProvider.autoDispose.family<String?, MediaCertification>((
      ref,
      certification,
    ) {
      return ref.watch(tvShowsRepositoryProvider).getCertificationMeaning(
        certification.code,
        region: certification.region,
      );
    });
