import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'movie_poster_link.dart';

class MovieMasonry extends StatefulWidget {
  const MovieMasonry({super.key, required this.movies, this.loadNextPage});

  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.loadNextPage == null ||
        !scrollController.hasClients ||
        scrollController.position.pixels + 100 <
            scrollController.position.maxScrollExtent) {
      return;
    }
    widget.loadNextPage!();
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          final poster = MoviePosterLink(movie: widget.movies[index]);
          return index == 1
              ? Padding(padding: const EdgeInsets.only(top: 40), child: poster)
              : poster;
        },
      ),
    );
  }
}
