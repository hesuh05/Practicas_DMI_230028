import 'package:flutter/material.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/shared/media_slideshow.dart';

class MoviesSlideshow extends StatelessWidget {
  const MoviesSlideshow({super.key, required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return MediaSlideshow<Movie>(
      items: movies,
      imageUrl: (movie) => movie.backdropPath,
      route: (movie) => '/home/0/movie/${movie.id}',
      previousLabel: 'Película anterior',
      nextLabel: 'Película siguiente',
    );
  }
}
