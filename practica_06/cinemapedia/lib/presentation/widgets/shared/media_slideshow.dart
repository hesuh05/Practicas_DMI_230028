import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/domain/entities/media_certification.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_rating.dart';
import 'package:cinemapedia/presentation/widgets/shared/certification_badge.dart';

class MediaSlideshow<T> extends StatefulWidget {
  const MediaSlideshow({
    super.key,
    required this.items,
    required this.imageUrl,
    required this.route,
    required this.title,
    required this.voteAverage,
    required this.certification,
    required this.certificationKey,
    required this.previousLabel,
    required this.nextLabel,
  });

  final List<T> items;
  final String Function(T item) imageUrl;
  final String Function(T item) route;
  final String Function(T item) title;
  final double Function(T item) voteAverage;
  final Future<MediaCertification> Function(T item) certification;
  final String Function(T item) certificationKey;
  final String previousLabel;
  final String nextLabel;

  @override
  State<MediaSlideshow<T>> createState() => _MediaSlideshowState<T>();
}

class _MediaSlideshowState<T> extends State<MediaSlideshow<T>> {
  final SwiperController _controller = SwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
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
                  color: colors.secondary,
                ),
              ),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return _Slide(
                  key: ValueKey(widget.certificationKey(item)),
                  imageUrl: widget.imageUrl(item),
                  route: widget.route(item),
                  title: widget.title(item),
                  voteAverage: widget.voteAverage(item),
                  certification: widget.certification(item),
                );
              },
            ),
            Positioned(
              left: 4,
              child: _CarouselArrow(
                icon: Icons.chevron_left_rounded,
                tooltip: widget.previousLabel,
                onTap: _controller.previous,
                onDoubleTap: () => _controller.move(0),
              ),
            ),
            Positioned(
              right: 4,
              child: _CarouselArrow(
                icon: Icons.chevron_right_rounded,
                tooltip: widget.nextLabel,
                onTap: _controller.next,
                onDoubleTap: () => _controller.move(widget.items.length - 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatefulWidget {
  const _Slide({
    super.key,
    required this.imageUrl,
    required this.route,
    required this.title,
    required this.voteAverage,
    required this.certification,
  });

  final String imageUrl;
  final String route;
  final String title;
  final double voteAverage;
  final Future<MediaCertification> certification;

  @override
  State<_Slide> createState() => _SlideState();
}

class _SlideState extends State<_Slide> {
  late Future<MediaCertification> _certification;

  @override
  void initState() {
    super.initState();
    _certification = widget.certification;
  }

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
          child: GestureDetector(
            onTap: () => context.push(widget.route),
            child: Stack(
              fit: StackFit.expand,
              children: [
                FadeInImage(
                  placeholder: const AssetImage(
                    'assets/loaders/wedge-loader.gif',
                  ),
                  placeholderFit: BoxFit.contain,
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(color: Colors.black, blurRadius: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          MovieRating(voteAverage: widget.voteAverage),
                          const SizedBox(width: 8),
                          FutureBuilder<MediaCertification>(
                            future: _certification,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Tooltip(
                                  message:
                                      'No se pudo cargar la clasificación: '
                                      '${snapshot.error}',
                                  child: const Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                );
                              }
                              final certification = snapshot.data;
                              if (certification == null ||
                                  certification.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return CertificationBadge(
                                certification: certification.label,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  const _CarouselArrow({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.onDoubleTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

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
