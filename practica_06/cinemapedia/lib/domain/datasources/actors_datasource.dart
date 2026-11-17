import 'package:cinemapedia/domain/entities/actor.dart';

abstract class ActorsDatasource {
  Future<List<Actor>> getActorsByMovie(String movieId);
  Future<List<Actor>> getActorsByTvShow(String tvShowId);
}
