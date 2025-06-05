class MoviePopular {
  int page;
  List<MoviePop> results;
  int totalPages;
  int totalResults;

  MoviePopular({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });
}

class MoviePop {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  OriginalLanguage originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  MoviePop({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });
}

enum OriginalLanguage { DE, EN, FR, HI }
