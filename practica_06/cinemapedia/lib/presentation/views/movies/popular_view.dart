import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularView extends ConsumerStatefulWidget {
  const PopularView({super.key});

  @override
  ConsumerState<PopularView> createState() => _PopularViewState();
}

class _PopularViewState extends ConsumerState<PopularView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final movies = ref.watch(popularMoviesProvider);
    if (movies.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    return MovieMasonry(
      movies: movies,
      loadNextPage: () =>
          ref.read(popularMoviesProvider.notifier).loadNextPage(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
