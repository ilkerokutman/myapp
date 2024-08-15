import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/movie.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.movie});
  final Movie movie;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Movie movie;
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    movie = widget.movie;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 600),
                  child: Image.network(
                    movie.image,
                    fit: BoxFit.contain,
                  ),
                ),

                ListTile(
                  title: const Text('Title:'),
                  subtitle: Text(
                    movie.title,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),

                // yonetmen
                ListTile(
                  title: const Text('Director:'),
                  subtitle: Text(movie.director),
                ),

                // yil
                ListTile(
                  title: const Text('Year:'),
                  subtitle: Text(movie.year.toString()),
                ),

                // puan
                ListTile(
                  title: const Text('IMDB Point:'),
                  subtitle: Text(
                    movie.imdbPoint.toStringAsFixed(1),
                  ),
                ),

                // oyuncular
                ListTile(
                  title: const Text('Actors:'),
                  subtitle: Text(
                    movie.actors.join('\n'),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 200),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'back_btn',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  FloatingActionButton.small(
                    heroTag: 'fav_btn',
                    onPressed: () {
                      setState(() {
                        movie.isFavorited = !movie.isFavorited;
                      });
                      box.write(movie.slug, movie.isFavorited ? 1 : 0);
                    },
                    child: Icon(movie.isFavorited
                        ? Icons.favorite
                        : Icons.favorite_outline),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
