import 'package:flutter/material.dart';

import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/presentation/widgets/shared/media_slideshow.dart';

class TvShowsSlideshow extends StatelessWidget {
  const TvShowsSlideshow({super.key, required this.shows});

  final List<TvShow> shows;

  @override
  Widget build(BuildContext context) {
    return MediaSlideshow<TvShow>(
      items: shows.take(5).toList(),
      imageUrl: (show) => show.backdropPath,
      route: (show) => '/home/0/tv-show/${show.id}',
      previousLabel: 'Serie anterior',
      nextLabel: 'Serie siguiente',
    );
  }
}
