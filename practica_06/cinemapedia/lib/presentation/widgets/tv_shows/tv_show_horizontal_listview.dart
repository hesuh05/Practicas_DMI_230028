import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:cinemapedia/domain/entities/tv_show.dart';

import 'tv_show_poster_link.dart';

class TvShowHorizontalListView extends StatefulWidget {
  const TvShowHorizontalListView({
    super.key,
    required this.shows,
    this.title,
    this.subTitle,
    this.loadNextPage,
  });

  final List<TvShow> shows;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  @override
  State<TvShowHorizontalListView> createState() =>
      _TvShowHorizontalListViewState();
}

class _TvShowHorizontalListViewState extends State<TvShowHorizontalListView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shows.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 320,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(title: widget.title, subTitle: widget.subTitle),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.shows.length,
              itemBuilder: (_, index) => FadeInRight(
                child: SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: TvShowPosterLink(
                      show: widget.shows[index],
                      showFavoriteButton: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const _Title({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null) Text(title!, style: titleStyle),
          const Spacer(),
          if (subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(subTitle!),
            ),
        ],
      ),
    );
  }
}