import 'dart:convert';
import 'package:dashbord_cine/models/movie_response.dart';
import 'package:http/http.dart' as http;

import '../models/movie_credit.dart';
import '../models/movie_details.dart';

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwM2RjYTJlNWVlMWJjZWEzZDc0ZWI5YTYyNjRhYjdlYiIsIm5iZiI6MTY5NTEzMTI5OS43ODgsInN1YiI6IjY1MDlhNmEzZmEyN2Y0MDEwYzRjMDIxYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.IchWLNeqrFklFPYRTE4v-E0eOh-xG7OA3Ry_Bpa9rRI';

  /*Future<MovieResponse> fetchNowPlayingMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/now_playing?language=en-US&page=1'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }*/

  Future<MovieResponse> fetchNowPlayingMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/now_playing?language=fr-FR&page=$page'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  Future<MovieResponse> fetchPopularMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular?language=fr-FR&page=$page'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  Future<MovieResponse> fetchTopRatedMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/top_rated?language=fr-FR&page=$page'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  // Dans MovieService
  Future<MovieDetails> fetchMovieDetails(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId?language=fr-FR'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return MovieDetails.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }

  Future<MovieCredits> fetchMovieCredits(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId/credits?language=fr-FR'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return MovieCredits.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load movie credits: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }
}
