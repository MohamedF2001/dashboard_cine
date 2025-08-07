import 'package:dashbord_cine/widgets/popular_movie.dart';
import 'package:flutter/material.dart';
import '../widgets/horizontal_movie_list.dart';
import '../widgets/top_rated_movie.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.5),
        centerTitle: true,
        title: const Text('Les films', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.5), // Noir très sombre
                Colors.black.withOpacity(0.6), // Noir un peu plus clair
                Colors.black.withOpacity(0.7), // Blanc très léger
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                HorizontalMovieList(),
                PopularMovieList(),
                TopRatedMovie(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
