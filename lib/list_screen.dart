import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/detail_screen.dart';
import 'package:myapp/movie.dart';
import 'package:myapp/movie_provider.dart';

extension CamelCaseToHumanReadable on String {
  String toHumanReadable() {
    // Regular expression to find where a lowercase letter is followed by an uppercase letter
    final RegExp exp = RegExp(r'(?<=[a-z])([A-Z])');

    // Insert a space before each uppercase letter and convert the whole string to lowercase
    final spacedString = replaceAllMapped(exp, (Match m) => ' ${m[0]}');

    // Capitalize the first letter of each word
    return spacedString.split(' ').map((word) => word.capitalize()).join(' ');
  }
}

extension CapitalizeExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
}

enum Sorting {
  none,
  imdbPointAsc,
  imdbPointDesc,
  yearAsc,
  yearDesc,
  titleAsc,
  titleDesc,
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final box = GetStorage();
  bool isFavoriteTabActive = false;
  Sorting sorting = Sorting.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isFavoriteTabActive ? 'My Favorite Movies' : 'Movie List'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: isFavoriteTabActive ? 1 : 0,
        onTap: (v) {
          setState(() {
            isFavoriteTabActive = v == 1;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'All Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'My Favorites',
          ),
        ],
      ),
      body: FutureBuilder(
        future: MovieProvider.fetchMovieList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Movie> movies = snapshot.data as List<Movie>;
              for (int i = 0; i < movies.length; i++) {
                movies[i].isFavorited = box.read(movies[i].slug) == 1;
              }
              if (isFavoriteTabActive) {
                movies = movies.where((e) => e.isFavorited).toList();
              }

              switch (sorting) {
                case Sorting.imdbPointAsc:
                  movies.sort((a, b) => a.imdbPoint.compareTo(b.imdbPoint));
                  break;
                case Sorting.imdbPointDesc:
                  movies.sort((a, b) => b.imdbPoint.compareTo(a.imdbPoint));
                  break;
                case Sorting.yearAsc:
                  movies.sort((a, b) => a.year.compareTo(b.year));
                  break;
                case Sorting.yearDesc:
                  movies.sort((a, b) => b.year.compareTo(a.year));
                  break;
                case Sorting.titleAsc:
                  movies.sort((a, b) => a.title.compareTo(b.title));
                  break;
                case Sorting.titleDesc:
                  movies.sort((a, b) => b.title.compareTo(a.title));
                  break;
                default:
                  break;
              }

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  DropdownMenu<Sorting>(
                    initialSelection: sorting,
                    leadingIcon: Icon(Icons.sort),
                    onSelected: (value) {
                      setState(() {
                        sorting = value!;
                      });
                    },
                    dropdownMenuEntries: Sorting.values
                        .map((e) => DropdownMenuEntry<Sorting>(
                            value: e, label: e.name.toHumanReadable()))
                        .toList(),
                  ),
                  Divider(),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3.5,
                      ),
                      itemBuilder: (context, index) {
                        final m = movies[index];
                        return Container(
                          margin: const EdgeInsets.all(8),
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(movie: m),
                                ),
                              );
                              setState(() {});
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Card(
                              elevation: 12,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      m.image,
                                      fit: BoxFit.cover,
                                    ),
                                    // Align(
                                    //   alignment: Alignment.topLeft,
                                    //   child: Chip(
                                    //     label: Text(m.year.toString()),
                                    //   ),
                                    // ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Opacity(
                                        opacity: 0.83,
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              right: 8,
                                              top: 4,
                                              bottom: 2,
                                              left: 8),
                                          decoration: const BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(14)),
                                          ),
                                          child: Text(
                                            m.imdbPoint.toStringAsFixed(1),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        width: double.infinity,
                                        height: 64,
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          m.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  shadows: [
                                                BoxShadow(
                                                  offset: const Offset(0, 0),
                                                  blurRadius: 14,
                                                  spreadRadius: 8,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .shadow,
                                                )
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: movies.length,
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: Text('No data'),
            );
          }

          return const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 12),
                Text('Loading movies...')
              ],
            ),
          );
        },
      ),
    );
  }
}
