import 'dart:convert';

class Movie {
  String slug;
  String title;
  String image;
  String director;
  int year;
  double imdbPoint;
  List<String> actors;
  bool isFavorited;
  Movie({
    required this.slug,
    required this.title,
    required this.image,
    required this.director,
    required this.year,
    required this.imdbPoint,
    required this.actors,
    required this.isFavorited,
  });

  Map<String, dynamic> toMap() {
    return {
      'slug': slug,
      'title': title,
      'image': image,
      'director': director,
      'year': year,
      'imdb_point': imdbPoint,
      'actors': actors,
      'isFavorited': isFavorited,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      slug: map['slug'] ?? '',
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      director: map['director'] ?? '',
      year: map['year']?.toInt() ?? 0,
      imdbPoint: map['imdb_point']?.toDouble() ?? 0.0,
      actors: List<String>.from(map['actors']),
      isFavorited: map['isFavorited'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) => Movie.fromMap(json.decode(source));
}
