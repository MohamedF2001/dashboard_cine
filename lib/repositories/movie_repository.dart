import 'package:dashbord_cine/models/movie_response.dart';

import '../services/movie_service.dart';

class MovieRepository {
  final MovieService _movieService = MovieService();

  Future<MovieResponse> getNowPlayingMovies() async {
    return await _movieService.fetchNowPlayingMovies();
  }

  // Autres méthodes qui pourraient combiner plusieurs appels de service
  //Future<List<Movie>> getPopularMoviesFirstPage() async {
  //final response = await _movieService.fetchPopularMovies();
  //  return response.results;
  //}
}
