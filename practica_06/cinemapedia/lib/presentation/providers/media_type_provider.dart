import 'package:flutter_riverpod/legacy.dart';

enum MediaType { movies, tvShows }

final mediaTypeProvider = StateProvider<MediaType>((ref) => MediaType.movies);
