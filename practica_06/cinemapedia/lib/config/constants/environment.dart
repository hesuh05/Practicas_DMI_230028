import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String theMovieDBKey = dotenv.env["THE_MOVIEDB_KEY"] ?? '5a3c852d4da40bd03bc8dc7b70d24393';
}