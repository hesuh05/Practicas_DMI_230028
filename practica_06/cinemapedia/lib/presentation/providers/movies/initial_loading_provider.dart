import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';
import '../tv_shows/tv_shows_providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final step2 = ref.watch(popularMoviesProvider).isEmpty;
  final step3 = ref.watch(topRatedMoviesProvider).isEmpty;
  final step4 = ref.watch(upcomingMoviesProvider).isEmpty;
  final step5 = ref.watch(popularTvShowsProvider).isEmpty;
  final step6 = ref.watch(onTheAirTvShowsProvider).isEmpty;
  final step7 = ref.watch(topRatedTvShowsProvider).isEmpty;

  if (step1 || step2 || step3 || step4 || step5 || step6 || step7) {
    return true;
  }

  return false; // terminamos de cargar
});
