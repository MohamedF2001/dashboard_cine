// lib/views/modern_movie_page.dart
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/responsive.dart';
import '../models/movie_response.dart';
import '../services/movie_service.dart';
import '../widgets/modern_movie_card.dart';
import 'movie_details_pagee.dart';

class MoviesPagee extends StatefulWidget {
  const MoviesPagee({Key? key}) : super(key: key);

  @override
  State<MoviesPagee> createState() => _MoviesPageeState();
}

class _MoviesPageeState extends State<MoviesPagee> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MovieService _movieService = MovieService();

  List<Movie> _nowPlayingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];

  bool _isLoading = true;
  int _nowPlayingPage = 1;
  int _popularPage = 1;
  int _topRatedPage = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAllMovies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllMovies() async {
    setState(() => _isLoading = true);

    try {
      final nowPlaying = await _movieService.fetchNowPlayingMovies(page: _nowPlayingPage);
      final popular = await _movieService.fetchPopularMovies(page: _popularPage);
      final topRated = await _movieService.fetchTopRatedMovies(page: _topRatedPage);

      setState(() {
        _nowPlayingMovies.addAll(nowPlaying.results);
        _popularMovies.addAll(popular.results);
        _topRatedMovies.addAll(topRated.results);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Future<void> _loadMoreMovies(int category) async {
    try {
      MovieResponse response;

      switch (category) {
        case 0:
          _nowPlayingPage++;
          response = await _movieService.fetchNowPlayingMovies(page: _nowPlayingPage);
          setState(() => _nowPlayingMovies.addAll(response.results));
          break;
        case 1:
          _popularPage++;
          response = await _movieService.fetchPopularMovies(page: _popularPage);
          setState(() => _popularMovies.addAll(response.results));
          break;
        case 2:
          _topRatedPage++;
          response = await _movieService.fetchTopRatedMovies(page: _topRatedPage);
          setState(() => _topRatedMovies.addAll(response.results));
          break;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = Responsive.isMobile(context)
        ? 2
        : Responsive.isTablet(context)
        ? 3
        : 5;

    return Container(
      decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Column(
        children: [
          // Tabs
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.primaryRed,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.textSecondary,
              tabs: [
                Tab(text: 'En ce moment'),
                Tab(text: 'Populaires'),
                Tab(text: 'Les mieux notés'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryRed,
              ),
            )
                : TabBarView(
              controller: _tabController,
              children: [
                _buildMovieGrid(_nowPlayingMovies, 0, crossAxisCount),
                _buildMovieGrid(_popularMovies, 1, crossAxisCount),
                _buildMovieGrid(_topRatedMovies, 2, crossAxisCount),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieGrid(List<Movie> movies, int category, int crossAxisCount) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return ModernMovieCard(
                movie: movies[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPagee(
                        movieId: movies[index].id,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Load more button
        Padding(
          padding: EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => _loadMoreMovies(category),
            icon: Icon(Icons.add_rounded),
            label: Text('Charger plus'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}



