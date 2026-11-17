import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:cinemapedia/domain/entities/tv_show.dart';

import 'tv_show_poster_link.dart';

class TvShowMasonry extends StatefulWidget {
  const TvShowMasonry({super.key, required this.shows, this.loadNextPage});

  final List<TvShow> shows;
  final VoidCallback? loadNextPage;

  @override
  State<TvShowMasonry> createState() => _TvShowMasonryState();
}

class _TvShowMasonryState extends State<TvShowMasonry> {
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
        itemCount: widget.shows.length,
        itemBuilder: (_, index) {
          final poster = TvShowPosterLink(show: widget.shows[index]);
          return index % 3 == 1
              ? poster
              : Padding(padding: const EdgeInsets.only(top: 40), child: poster);
        },
      ),
    );
  }
}
