import 'package:dashbord_cine/models/movie_response.dart';
import 'package:flutter/foundation.dart';
import '../repositories/movie_repository.dart';

class MovieProvider with ChangeNotifier {
  final MovieRepository _repository = MovieRepository();
  List<Movie> _movies = [];
  bool _isLoading = false;
  String _error = '';

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadNowPlayingMovies() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await _repository.getNowPlayingMovies();
      _movies = response.results;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
