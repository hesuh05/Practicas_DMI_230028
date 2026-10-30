import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class MoviesSlideshow extends StatefulWidget {
  final List<Movie> movies;

  const MoviesSlideshow({
    super.key,
    required this.movies,
  });

  @override
  State<MoviesSlideshow> createState() => _MoviesSlideshowState();
}

class _MoviesSlideshowState extends State<MoviesSlideshow> {
  final SwiperController _controller = SwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 310,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Swiper(
            controller: _controller,
            pagination: SwiperPagination(
              margin: const EdgeInsets.only(top: 0),
              builder: DotSwiperPaginationBuilder(
                activeColor: colors.primary,
                color: colors.secondary
              )
            ),
            itemCount: widget.movies.length,
            itemBuilder: (context, index) =>
                _Slide(movie: widget.movies[index]),
          ),
          Positioned(
            left: 4,
            child: _CarouselArrow(
              icon: Icons.chevron_left_rounded,
              tooltip: 'Película anterior',
              onTap: () => _controller.previous(),
              onDoubleTap: () => _controller.move(0),
            ),
          ),
          Positioned(
            right: 4,
            child: _CarouselArrow(
              icon: Icons.chevron_right_rounded,
              tooltip: 'Película siguiente',
              onTap: () => _controller.next(),
              onDoubleTap: () => _controller.move(widget.movies.length - 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const _CarouselArrow({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: Colors.white,
              size: 42,
              shadows: const [
                Shadow(
                  color: Colors.black87,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        const BoxShadow(
          color: Colors.black45,
          blurRadius: 10,
          offset: Offset(0, 10),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) {
                return const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12),
                );
              }
              return FadeIn(
                duration: const Duration(milliseconds: 600),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
