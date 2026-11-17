import 'package:cinemapedia/config/helpers/certification_meaning.dart';
import 'package:cinemapedia/infrastructure/mappers/certification_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/tv_show_moviedb.dart';
import 'package:cinemapedia/presentation/widgets/shared/certification_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('localizes Mexican and US age-rating meanings', () {
    expect(
      CertificationMeaning.localized(
        certification: 'B15',
        region: 'MX',
        language: 'MX',
        media: CertificationMedia.movie,
      ),
      'No recomendada para menores de 15 años.',
    );
    expect(
      CertificationMeaning.localized(
        certification: 'B-15',
        region: 'MX',
        language: 'MX',
        media: CertificationMedia.movie,
      ),
      'No recomendada para menores de 15 años.',
    );
    expect(
      CertificationMeaning.localized(
        certification: 'PG-13',
        region: 'US',
        language: 'US',
        media: CertificationMedia.movie,
      ),
      contains('under 13'),
    );
    expect(
      CertificationMeaning.localized(
        certification: 'B15',
        region: 'CN',
        language: 'CN',
        media: CertificationMedia.movie,
      ),
      contains('15岁以下'),
    );
  });

  test('reads a country-specific TMDB certification meaning', () {
    final response = {
      'certifications': {
        'US': [
          {'certification': 'PG-13', 'meaning': 'Official English meaning'},
        ],
        'MX': [
          {'certification': 'B15', 'meaning': 'Descripción oficial'},
        ],
      },
    };

    expect(
      CertificationMapper.meaningForRegion(
        response,
        region: 'MX',
        certification: 'B15',
      ),
      'Descripción oficial',
    );
    expect(
      CertificationMapper.meaningForRegion(
        response,
        region: 'DE',
        certification: 'B15',
      ),
      isNull,
    );
  });

  test('movie certification matches the selected region', () {
    final releaseDates = {
      'results': [
        {
          'iso_3166_1': 'MX',
          'release_dates': [
            {'certification': 'B', 'type': 2},
            {'certification': 'B15', 'type': 3},
          ],
        },
        {
          'iso_3166_1': 'US',
          'release_dates': [
            {'certification': 'R', 'type': 3},
          ],
        },
      ],
    };

    final mexicanRating = MovieDetails.certificationForRegion(
      releaseDates,
      'MX',
    );
    expect(mexicanRating.code, 'B15');
    expect(mexicanRating.region, 'MX');
    expect(mexicanRating.isFallback, isFalse);

    final usRating = MovieDetails.certificationForRegion(releaseDates, 'US');
    expect(usRating.code, 'R');
    expect(usRating.region, 'US');
    expect(usRating.isFallback, isFalse);

    final fallback = MovieDetails.certificationForRegion(releaseDates, 'CN');
    expect(fallback.code, 'R');
    expect(fallback.region, 'US');
    expect(fallback.isFallback, isTrue);
    expect(fallback.label, 'US · R');
  });

  test('series certification matches the selected region', () {
    final contentRatings = {
      'results': [
        {'iso_3166_1': 'MX', 'rating': 'B15'},
        {'iso_3166_1': 'US', 'rating': 'TV-MA'},
      ],
    };

    final usRating = TvShowMapper.certificationForRegion(contentRatings, 'US');
    expect(usRating.code, 'TV-MA');
    expect(usRating.region, 'US');
    expect(usRating.isFallback, isFalse);

    final fallback = TvShowMapper.certificationForRegion(contentRatings, 'EG');
    expect(fallback.code, 'TV-MA');
    expect(fallback.region, 'US');
    expect(fallback.isFallback, isTrue);
  });

  test('series details retain a fallback rating when CN has none', () {
    final show = TvShowMapper.fromJson({
      'id': 42,
      'content_ratings': {
        'results': [
          {'iso_3166_1': 'US', 'rating': 'TV-MA'},
        ],
      },
    }, region: 'CN');

    expect(show.certification.code, 'TV-MA');
    expect(show.certification.region, 'US');
    expect(show.certification.label, 'US · TV-MA');
  });

  testWidgets('renders the regional certification', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: CertificationBadge(certification: 'B15')),
      ),
    );

    expect(find.text('B15'), findsOneWidget);
  });
}
