/*
import 'package:dashbord_cine/models/movie_response.dart';
import 'package:dashbord_cine/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import '../services/movie_service.dart';

class HorizontalMovieList extends StatefulWidget {
  @override
  State<HorizontalMovieList> createState() => _HorizontalMovieListState();
}

class _HorizontalMovieListState extends State<HorizontalMovieList> {
  final MovieService movieService = MovieService();
  late Future<MovieResponse> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() {
    setState(() {
      _moviesFuture = movieService.fetchNowPlayingMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieResponse>(
      future: movieService.fetchNowPlayingMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return Center(child: Text('No movies found'));
        }

        final movies = snapshot.data!.results;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Now Playing',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieCard(movie: movie);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
*/

import 'package:dashbord_cine/models/movie_response.dart';
import 'package:dashbord_cine/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import '../services/movie_service.dart';

class HorizontalMovieList extends StatefulWidget {
  @override
  State<HorizontalMovieList> createState() => _HorizontalMovieListState();
}

class _HorizontalMovieListState extends State<HorizontalMovieList> {
  final MovieService movieService = MovieService();
  List<Movie> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await movieService.fetchNowPlayingMovies(page: _currentPage);

      setState(() {
        _movies.addAll(response.results);
        _currentPage++;
        _hasMore = response.results.isNotEmpty;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'En ce moment',
            style: TextStyle(fontWeight: FontWeight.bold,
    fontSize: 16,color: Colors.white,)
          ),
        ),
        SizedBox(
          height: 320,
          child: _movies.isEmpty && _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _movies.length,
            itemBuilder: (context, index) {
              final movie = _movies[index];
              return MovieCard(movie: movie);
            },
          ),
        ),
        if (_hasMore)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style:  ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Couleur du bouton
                  foregroundColor: Colors.white, // Couleur du texte
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12), // Bordures arrondies
                  ),

                  textStyle: const TextStyle(
                     fontWeight: FontWeight.bold),
                ),
                onPressed: _isLoading ? null : _loadMovies,
                child: _isLoading
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text('Charger plus'),
              ),
            ),
          ),
      ],
    );
  }
}

