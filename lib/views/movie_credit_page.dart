import 'package:flutter/material.dart';
import '../models/movie_credit.dart';
import '../services/movie_service.dart';

class MovieCreditsPage extends StatefulWidget {
  final int movieId;

  const MovieCreditsPage({super.key, required this.movieId});

  @override
  _MovieCreditsPageState createState() => _MovieCreditsPageState();
}

class _MovieCreditsPageState extends State<MovieCreditsPage> {
  late Future<MovieCredits> _movieCredits;
  final MovieService _movieService = MovieService();

  @override
  void initState() {
    super.initState();
    _movieCredits = _movieService.fetchMovieCredits(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Credits')),
      body: FutureBuilder<MovieCredits>(
        future: _movieCredits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No credits found'));
          }

          final credits = snapshot.data!;

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(tabs: [Tab(text: 'Cast'), Tab(text: 'Crew')]),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Onglet Cast
                      ListView.builder(
                        itemCount: credits.cast.length,
                        itemBuilder: (context, index) {
                          final cast = credits.cast[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                cast.fullProfilePath,
                              ),
                            ),
                            title: Text(cast.name),
                            subtitle: Text(
                              cast.character ?? 'Unknown character',
                            ),
                            trailing: Text('#${cast.order}'),
                          );
                        },
                      ),

                      // Onglet Crew
                      ListView.builder(
                        itemCount: credits.crew.length,
                        itemBuilder: (context, index) {
                          final crew = credits.crew[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                crew.fullProfilePath,
                              ),
                            ),
                            title: Text(crew.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(crew.job), Text(crew.department)],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
