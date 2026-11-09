import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  late final Future<Isar> db;

  IsarDatasource() {
    db = _openDb();
  }

  Future<Isar> _openDb() async {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    final directory = await getApplicationDocumentsDirectory();
    return Isar.open([MovieSchema], directory: directory.path);
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;
    final movie = await isar.movies.filter().idEqualTo(movieId).findFirst();
    return movie != null;
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;
    final favoriteMovie = await isar.movies
        .filter()
        .idEqualTo(movie.id)
        .findFirst();

    await isar.writeTxn(() async {
      if (favoriteMovie != null) {
        await isar.movies.delete(favoriteMovie.isarId!);
      } else {
        await isar.movies.put(movie);
      }
    });
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, int offset = 0}) async {
    final isar = await db;
    return isar.movies.where().offset(offset).limit(limit).findAll();
  }
}
