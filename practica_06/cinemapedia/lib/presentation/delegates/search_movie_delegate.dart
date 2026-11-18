import 'dart:async';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

typedef SearchMediaCallback<T> = Future<List<T>> Function(String query);

class SearchMediaDelegate<T> extends SearchDelegate<T?> {
  SearchMediaDelegate({
    required this.searchMedia,
    required this.initialItems,
    required this.titleOf,
    required this.posterOf,
    required this.overviewOf,
    required this.voteAverageOf,
    required String searchFieldLabel,
  }) : super(searchFieldLabel: searchFieldLabel);

  final SearchMediaCallback<T> searchMedia;
  final String Function(T item) titleOf;
  final String Function(T item) posterOf;
  final String Function(T item) overviewOf;
  final double Function(T item) voteAverageOf;
  List<T> initialItems;

  final StreamController<List<T>> debouncedItems =
      StreamController<List<T>>.broadcast();
  final StreamController<bool> isLoadingStream =
      StreamController<bool>.broadcast();

  Timer? _debounceTimer;

  void clearStreams() {
    _debounceTimer?.cancel();
    if (!debouncedItems.isClosed) debouncedItems.close();
    if (!isLoadingStream.isClosed) isLoadingStream.close();
  }

  void _onQueryChanged(String query) {
    if (query.trim().isEmpty) {
      _debounceTimer?.cancel();
      initialItems = [];
      if (!debouncedItems.isClosed) debouncedItems.add([]);
      if (!isLoadingStream.isClosed) isLoadingStream.add(false);
      return;
    }

    isLoadingStream.add(true);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final items = await searchMedia(query);
        initialItems = items;
        if (!debouncedItems.isClosed) debouncedItems.add(items);
      } catch (error, stackTrace) {
        if (!debouncedItems.isClosed) {
          debouncedItems.addError(error, stackTrace);
        }
      } finally {
        if (!isLoadingStream.isClosed) isLoadingStream.add(false);
      }
    });
  }

  Widget _buildResultsAndSuggestions() {
    return StreamBuilder<List<T>>(
      initialData: initialItems,
      stream: debouncedItems.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error al buscar: ${snapshot.error}'));
        }

        final items = snapshot.data ?? [];
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => _MediaItem<T>(
            item: items[index],
            titleOf: titleOf,
            posterOf: posterOf,
            overviewOf: overviewOf,
            voteAverageOf: voteAverageOf,
            onSelected: (item) {
              clearStreams();
              close(context, item);
            },
          ),
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    StreamBuilder<bool>(
      initialData: false,
      stream: isLoadingStream.stream,
      builder: (context, snapshot) {
        if (snapshot.data ?? false) {
          return SpinPerfect(
            duration: const Duration(seconds: 20),
            spins: 10,
            infinite: true,
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.refresh_rounded),
            ),
          );
        }

        return FadeIn(
          animate: query.isNotEmpty,
          child: IconButton(
            onPressed: () => query = '',
            icon: const Icon(Icons.clear),
          ),
        );
      },
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () {
      clearStreams();
      close(context, null);
    },
    icon: const Icon(Icons.arrow_back_ios_new_rounded),
  );

  @override
  Widget buildResults(BuildContext context) => _buildResultsAndSuggestions();

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return _buildResultsAndSuggestions();
  }
}

class _MediaItem<T> extends StatelessWidget {
  const _MediaItem({
    required this.item,
    required this.titleOf,
    required this.posterOf,
    required this.overviewOf,
    required this.voteAverageOf,
    required this.onSelected,
  });

  final T item;
  final String Function(T item) titleOf;
  final String Function(T item) posterOf;
  final String Function(T item) overviewOf;
  final double Function(T item) voteAverageOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final overview = overviewOf(item);

    return GestureDetector(
      onTap: () => onSelected(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  placeholder: const AssetImage(
                    'assets/loaders/wedge-loader.gif',
                  ),
                  image: NetworkImage(posterOf(item)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titleOf(item), style: textStyles.titleMedium),
                  Text(
                    overview.length > 100
                        ? '${overview.substring(0, 100)}...'
                        : overview,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormats.number(voteAverageOf(item), 1),
                        style: textStyles.bodyMedium!.copyWith(
                          color: Colors.yellow.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
