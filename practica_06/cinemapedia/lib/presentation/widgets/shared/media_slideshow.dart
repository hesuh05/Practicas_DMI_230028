import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MediaSlideshow<T> extends StatefulWidget {
  const MediaSlideshow({
    super.key,
    required this.items,
    required this.imageUrl,
    required this.route,
    required this.previousLabel,
    required this.nextLabel,
  });

  final List<T> items;
  final String Function(T item) imageUrl;
  final String Function(T item) route;
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
                color: colors.secondary,
              ),
            ),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return _Slide(
                imageUrl: widget.imageUrl(item),
                route: widget.route(item),
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
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.imageUrl, required this.route});

  final String imageUrl;
  final String route;

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
            onTap: () => context.push(route),
            child: SizedBox.expand(
              child: FadeInImage(
                placeholder: const AssetImage(
                  'assets/loaders/wedge-loader.gif',
                ),
                placeholderFit: BoxFit.contain,
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
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
