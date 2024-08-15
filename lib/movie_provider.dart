import 'dart:io';
import 'package:dio/dio.dart';
import 'package:myapp/movie.dart';

class MovieProvider {
  static Future<List<Movie>> fetchMovieList() async {
    List<Movie> result = [];
    const url = "https://static.api2.run/movies/movies.json";
    final Dio dio = Dio();
    try {
      final response = await dio.get(url);
      if (response.statusCode == HttpStatus.ok) {
        final data = response.data;
        final movies = data['movies']; // as Map<String, dynamic>;
        for (final map in movies) {
          result.add(Movie.fromMap(map));
        }
      }
    } on Exception catch (_) {
      return [];
    }
    return result;
  }
}
