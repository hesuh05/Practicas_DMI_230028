import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';

class ActorsByTvShow extends ConsumerWidget {
  const ActorsByTvShow({super.key, required this.tvShowId});

  final String tvShowId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actors = ref.watch(actorsByTvShowProvider)[tvShowId];
    if (actors == null) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (_, index) {
          final actor = actors[index];
          return SizedBox(
            width: 135,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInRight(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FadeInImage(
                        height: 180,
                        width: 135,
                        fit: BoxFit.cover,
                        placeholder: const AssetImage(
                          'assets/loaders/wedge-loader.gif',
                        ),
                        image: NetworkImage(actor.profilePath),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(actor.name, maxLines: 2),
                  Text(
                    actor.character ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
