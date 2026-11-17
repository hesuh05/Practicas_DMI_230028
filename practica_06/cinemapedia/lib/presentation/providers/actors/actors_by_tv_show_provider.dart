import 'package:flutter_riverpod/legacy.dart';

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';

final actorsByTvShowProvider =
    StateNotifierProvider<ActorsByTvShowNotifier, Map<String, List<Actor>>>(
  (ref) => ActorsByTvShowNotifier(
    getActors: ref.watch(actorsRepositoryProvider).getActorsByTvShow,
  ),
);

class ActorsByTvShowNotifier
    extends StateNotifier<Map<String, List<Actor>>> {
  ActorsByTvShowNotifier({required this.getActors}) : super({});

  final Future<List<Actor>> Function(String id) getActors;

  Future<void> loadActors(String id) async {
    if (state[id] != null) return;
    state = {...state, id: await getActors(id)};
  }
}
