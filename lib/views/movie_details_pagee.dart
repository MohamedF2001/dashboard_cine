/*import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';
import '../models/movie_credit.dart';
import '../models/movie_details.dart';
import '../services/movie_service.dart';

class MovieDetailPagee extends StatefulWidget {
  final int movieId;

  const MovieDetailPagee({super.key, required this.movieId});

  @override
  _MovieDetailPageeState createState() => _MovieDetailPageeState();
}

class _MovieDetailPageeState extends State<MovieDetailPagee>
    with TickerProviderStateMixin {
  late Future<MovieDetails> _movieDetails;
  late Future<MovieCredits> _movieCredits;
  final MovieService _movieService = MovieService();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _movieDetails = _movieService.fetchMovieDetails(widget.movieId);
    _movieCredits = _movieService.fetchMovieCredits(widget.movieId);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movieId;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      appBar: AppBar(
        foregroundColor: Colors.white70,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.5),
        centerTitle: true,
        title: const Text('Détails', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
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
        child: FutureBuilder(
          future: Future.wait([_movieDetails, _movieCredits]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            }

            final movie = snapshot.data![0] as MovieDetails;
            final credits = snapshot.data![1] as MovieCredits;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Détails du film
                  _buildMovieHeader(movie),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        //_buildAnimatedSection( _buildGenresSection(movie),),
                        //const SizedBox(height: 30),
                        _buildAnimatedSection(_buildDetailsSection(movie)),
                        const SizedBox(height: 30),

                        // Section Cast complète
                        _buildSectionTitle('Casting'),
                        const SizedBox(height: 10),
                        _buildCastGrid(credits.cast),
                        const SizedBox(height: 30),

                        // Section Crew organisée par département
                        _buildSectionTitle('Équipe'),
                        const SizedBox(height: 10),
                        _buildCrewByDepartment(credits.crew),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  *//*Widget _buildMovieHeader(MovieDetails movie) {
    return Column(
      children: [
        if (movie.posterPath != null)
          Container(
            decoration: BoxDecoration(
              color: Colors.black26
            ),
            width: double.infinity,
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
              height: 550,
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(height: 16),
        Text(
          movie.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (movie.tagline?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '"${movie.tagline}"',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
      ],
    );
  }

  Widget _buildMovieOverview(MovieDetails movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Aperçu'),
        const SizedBox(height: 8),
        Text(movie.overview),
      ],
    );
  }

  Widget _buildGenresSection(MovieDetails movie) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: movie.genres
          .map((genre) => Chip(
        label: Text(genre.name),
        backgroundColor: Colors.blue[100],
      ))
          .toList(),
    );
  }

  Widget _buildDetailsSection(MovieDetails movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Details'),
        const SizedBox(height: 8),
        _buildDetailRow('Date de sortie', movie.releaseDate ?? 'N/A'),
        _buildDetailRow('Durée', '${movie.runtime ?? 0} minutes'),
        _buildDetailRow('Status', movie.status),
        _buildDetailRow('Budget', '\$${movie.budget.toStringAsFixed(0)}'),
        _buildDetailRow('Notation', '${movie.voteAverage}/10 (${movie.voteCount} votes)'),
      ],
    );
  }*//*

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[600]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header shimmer
            Container(height: 550, width: double.infinity, color: Colors.white),
            const SizedBox(height: 20),

            // Overview shimmer
            Container(width: double.infinity, height: 20, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: double.infinity, height: 16, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: 300, height: 16, color: Colors.white),
            const SizedBox(height: 30),

            // Genres shimmer
            Container(width: 100, height: 20, color: Colors.white),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 30,
                  color: Colors.white,
                  margin: const EdgeInsets.only(right: 8),
                ),
                Container(
                  width: 60,
                  height: 30,
                  color: Colors.white,
                  margin: const EdgeInsets.only(right: 8),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Details shimmer
            Container(width: 100, height: 20, color: Colors.white),
            const SizedBox(height: 8),
            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(width: 24, height: 24, color: Colors.white),
                    const SizedBox(width: 8),
                    Container(width: 100, height: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Container(width: 150, height: 16, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Cast shimmer
            Container(width: 100, height: 20, color: Colors.white),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 8,
              itemBuilder:
                  (_, __) => Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(width: 60, height: 12, color: Colors.white),
                      const SizedBox(height: 4),
                      Container(width: 50, height: 10, color: Colors.white),
                    ],
                  ),
            ),
            const SizedBox(height: 30),

            // Crew shimmer
            Container(width: 100, height: 20, color: Colors.white),
            const SizedBox(height: 10),
            ...List.generate(
              3,
              (index) => Column(
                children: [
                  Container(
                    width: 100,
                    height: 18,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8),
                  ),
                  ...List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 150,
                            height: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(_fadeAnimation),
      child: child,
    );
  }

  Widget _buildMovieHeader(MovieDetails movie) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 550,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 550,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54, Colors.black87],
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 24,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildGenresSection(movie),
              const SizedBox(height: 8),
              SizedBox(width: 700, child: _buildMovieOverview(movie)),
              const SizedBox(height: 8),
              if (movie.tagline?.isNotEmpty ?? false)
                Text(
                  '"${movie.tagline}"',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none),
                    label: const Text('Me rappeler'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Plus d\'infos'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white70),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_circle_fill_outlined),
                    label: const Text('Bande-annonce'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        *//*const Positioned(
          bottom: 20,
          right: 16,
          child: Chip(
            backgroundColor: Colors.purple,
            label: Text(
              'Saison 2 bientôt',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),*//*
      ],
    );
  }

  Widget _buildMovieOverview(MovieDetails movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //_buildSectionTitle('Aperçu'),
        const SizedBox(height: 8),
        Text(
          movie.overview,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildGenresSection(MovieDetails movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //_buildSectionTitle('Genres'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              movie.genres
                  .map(
                    (genre) => Chip(
                      label: Text(genre.name),
                      backgroundColor: Colors.grey[800],
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(MovieDetails movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Détails'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDetailRow(
                Icons.calendar_today,
                'Date de sortie',
                movie.releaseDate ?? 'N/A',
              ),
            ),
            Expanded(
              child: _buildDetailRow(
                Icons.timer,
                'Durée',
                '${movie.runtime ?? 0} min',
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildDetailRow(
                Icons.info_outline,
                'Statut',
                movie.status,
              ),
            ),
            Expanded(
              child: _buildDetailRow(
                Icons.attach_money,
                'Budget',
                '\$${movie.budget.toStringAsFixed(0)}',
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        _buildDetailRow(Icons.star, 'Notation', ''),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: RatingBarIndicator(
            rating: movie.voteAverage / 2,
            itemBuilder:
                (context, _) => const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 24,
            unratedColor: Colors.white24,
            direction: Axis.horizontal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, top: 4),
          child: Text(
            '${movie.voteAverage}/10 (${movie.voteCount} votes)',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Expanded(
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 25),
            const SizedBox(width: 8),
            Text('$label: ', style: const TextStyle(color: Colors.white)),
            Expanded(
              child: Text(value, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCastGrid(List<CastMember> cast) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: cast.length,
      itemBuilder: (context, index) {
        final actor = cast[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(actor.fullProfilePath),
            ),
            SizedBox(height: 5),
            Text(
              actor.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              actor.character ?? 'Unknown',
              style: const TextStyle(fontSize: 12, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCrewByDepartment(List<CrewMember> crew) {
    final departments = {
      'Direction': crew.where((p) => p.department == 'Directing').toList(),
      'Ecriture': crew.where((p) => p.department == 'Writing').toList(),
      'Production': crew.where((p) => p.department == 'Production').toList(),
      'Caméra': crew.where((p) => p.department == 'Camera').toList(),
      'Son': crew.where((p) => p.department == 'Sound').toList(),
      'Art': crew.where((p) => p.department == 'Art').toList(),
      'Édition': crew.where((p) => p.department == 'Editing').toList(),
      'Costume et maquillage':
          crew.where((p) => p.department == 'Costume & Make-Up').toList(),
      'Effets visuels':
          crew.where((p) => p.department == 'Visual Effects').toList(),
      'Équipe': crew.where((p) => p.department == 'Crew').toList(),
    };

    return Column(
      children:
          departments.entries.map((entry) {
            if (entry.value.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ...entry.value.map(
                  (person) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            person.job,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            person.name,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
    );
  }
}*/







// ===================================
// FICHIER 1: lib/views/modern_movie_details_page.dart
// Remplace movie_details_pagee.dart
// ===================================


/*import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie_credit.dart';
import '../models/movie_details.dart';
import '../services/movie_service.dart';

class MovieDetailPagee extends StatefulWidget {
  final int movieId;

  const MovieDetailPagee({super.key, required this.movieId});

  @override
  _MovieDetailPageeState createState() => _MovieDetailPageeState();
}

class _MovieDetailPageeState extends State<MovieDetailPagee>
    with TickerProviderStateMixin {
  late Future<MovieDetails> _movieDetails;
  late Future<MovieCredits> _movieCredits;
  final MovieService _movieService = MovieService();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _movieDetails = _movieService.fetchMovieDetails(widget.movieId);
    _movieCredits = _movieService.fetchMovieCredits(widget.movieId);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();

    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showAppBarTitle) {
        setState(() => _showAppBarTitle = true);
      } else if (_scrollController.offset <= 200 && _showAppBarTitle) {
        setState(() => _showAppBarTitle = false);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
        _showAppBarTitle ? Color(0xFF1E1E1E) : Colors.transparent,
        elevation: _showAppBarTitle ? 4 : 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: _showAppBarTitle
            ? FutureBuilder<MovieDetails>(
          future: _movieDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                snapshot.data!.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return SizedBox();
          },
        )
            : null,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([_movieDetails, _movieCredits]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
                child: Text(
                  'Aucune donnée trouvée',
                  style: TextStyle(color: Colors.white),
                ));
          }

          final movie = snapshot.data![0] as MovieDetails;
          final credits = snapshot.data![1] as MovieCredits;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Header avec image
              SliverToBoxAdapter(
                child: _buildMovieHeader(movie),
              ),

              // Contenu scrollable
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),
                      _buildAnimatedSection(_buildDetailsSection(movie)),
                      SizedBox(height: 32),
                      _buildSectionTitle('Synopsis'),
                      SizedBox(height: 12),
                      _buildAnimatedSection(_buildMovieOverview(movie)),
                      SizedBox(height: 32),
                      _buildSectionTitle('Casting Principal'),
                      SizedBox(height: 16),
                      _buildCastList(credits.cast.take(10).toList()),
                      SizedBox(height: 32),
                      _buildSectionTitle('Équipe Technique'),
                      SizedBox(height: 16),
                      _buildCrewSection(credits.crew),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedSection(Widget child) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_fadeAnimation),
        child: child,
      ),
    );
  }

  Widget _buildMovieHeader(MovieDetails movie) {
    return Stack(
      children: [
        // Backdrop image
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
                Color(0xFF121212),
              ],
              stops: [0.0, 0.5, 1.0],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.dstIn,
          child: Image.network(
            'https://image.tmdb.org/t/p/original${movie.backdropPath}',
            width: double.infinity,
            height: 500,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 500,
              color: Color(0xFF1E1E1E),
            ),
          ),
        ),

        // Content overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Poster
                Container(
                  width: 140,
                  height: 210,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Color(0xFF2A2A2A),
                        child: Icon(Icons.movie, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),

                // Movie info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      if (movie.tagline?.isNotEmpty ?? false) ...[
                        SizedBox(height: 8),
                        Text(
                          '"${movie.tagline}"',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                      ],
                      SizedBox(height: 12),
                      _buildGenresChips(movie.genres),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildActionButton(
                            icon: Icons.play_circle_fill,
                            label: 'Bande-annonce',
                            isPrimary: true,
                            onTap: () {},
                          ),
                          _buildActionButton(
                            icon: Icons.add,
                            label: 'Ma liste',
                            isPrimary: false,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenresChips(List<Genre> genres) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres.take(4).map((genre) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            genre.name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? Color(0xFFE50914) : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(MovieDetails movie) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1E1E),
            Color(0xFF2A2A2A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.calendar_today,
                  label: 'Sortie',
                  value: movie.releaseDate?.substring(0, 4) ?? 'N/A',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.access_time,
                  label: 'Durée',
                  value: '${movie.runtime ?? 0} min',
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.star, color: Color(0xFFFFD700), size: 32),
                    SizedBox(height: 8),
                    RatingBarIndicator(
                      rating: movie.voteAverage / 2,
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: Color(0xFFFFD700)),
                      itemCount: 5,
                      itemSize: 20,
                      unratedColor: Colors.white24,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${movie.voteAverage.toStringAsFixed(1)}/10',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${movie.voteCount} votes',
                      style: TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.attach_money,
                  label: 'Budget',
                  value: '\$${(movie.budget / 1000000).toStringAsFixed(0)}M',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFFE50914), size: 28),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFFB3B3B3),
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMovieOverview(MovieDetails movie) {
    return Text(
      movie.overview,
      style: TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 15,
        height: 1.6,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Color(0xFFE50914),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCastList(List<CastMember> cast) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final actor = cast[index];
          return Container(
            width: 120,
            margin: EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFFE50914), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE50914).withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      actor.fullProfilePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Color(0xFF2A2A2A),
                        child: Icon(Icons.person, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  actor.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  actor.character ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFB3B3B3),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCrewSection(List<CrewMember> crew) {
    final directors = crew.where((p) => p.job == 'Director').take(3).toList();
    final writers = crew.where((p) => p.job == 'Writer').take(3).toList();
    final producers = crew.where((p) => p.job == 'Producer').take(3).toList();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (directors.isNotEmpty) _buildCrewRow('Réalisation', directors),
          if (writers.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildCrewRow('Scénario', writers),
          ],
          if (producers.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildCrewRow('Production', producers),
          ],
        ],
      ),
    );
  }

  Widget _buildCrewRow(String role, List<CrewMember> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          role,
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: members.map((member) {
            return Text(
              member.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}*/





import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie_credit.dart';
import '../models/movie_details.dart';
import '../services/movie_service.dart';

class MovieDetailPagee extends StatefulWidget {
  final int movieId;

  const MovieDetailPagee({super.key, required this.movieId});

  @override
  _MovieDetailPageeState createState() => _MovieDetailPageeState();
}

class _MovieDetailPageeState extends State<MovieDetailPagee>
    with TickerProviderStateMixin {
  late Future<MovieDetails> _movieDetails;
  late Future<MovieCredits> _movieCredits;
  final MovieService _movieService = MovieService();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _movieDetails = _movieService.fetchMovieDetails(widget.movieId);
    _movieCredits = _movieService.fetchMovieCredits(widget.movieId);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();

    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showAppBarTitle) {
        setState(() => _showAppBarTitle = true);
      } else if (_scrollController.offset <= 200 && _showAppBarTitle) {
        setState(() => _showAppBarTitle = false);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: FutureBuilder(
        future: Future.wait([_movieDetails, _movieCredits]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
                child: Text(
                  'Aucune donnée trouvée',
                  style: TextStyle(color: Colors.white),
                ));
          }

          final movie = snapshot.data![0] as MovieDetails;
          final credits = snapshot.data![1] as MovieCredits;

          return Stack(
            children: [
              // Contenu scrollable
              SingleChildScrollView(
                //controller: _scrollController,
                //physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMovieHeader(movie),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),
                          _buildAnimatedSection(_buildDetailsSection(movie)),
                          SizedBox(height: 32),
                          _buildSectionTitle('Synopsis'),
                          SizedBox(height: 12),
                          _buildAnimatedSection(_buildMovieOverview(movie)),
                          SizedBox(height: 32),
                          _buildSectionTitle('Casting Principal'),
                          SizedBox(height: 16),
                          _buildCastList(credits.cast.take(10).toList()),
                          SizedBox(height: 32),
                          _buildSectionTitle('Équipe Technique'),
                          SizedBox(height: 16),
                          _buildCrewSection(credits.crew),
                          SizedBox(height: 100), // Padding en bas pour éviter que le FAB cache le contenu
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // AppBar flottant
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: _showAppBarTitle
                        ? Color(0xFF1E1E1E)
                        : Colors.transparent,
                    boxShadow: _showAppBarTitle
                        ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                        : [],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          if (_showAppBarTitle) ...[
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                movie.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ] else
                            Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.share, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.favorite_border, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedSection(Widget child) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_fadeAnimation),
        child: child,
      ),
    );
  }

  Widget _buildMovieHeader(MovieDetails movie) {
    return Stack(
      children: [
        // Backdrop image
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
                Color(0xFF121212),
              ],
              stops: [0.0, 0.5, 1.0],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.dstIn,
          child: Image.network(
            'https://image.tmdb.org/t/p/original${movie.backdropPath}',
            width: double.infinity,
            height: 500,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 500,
              color: Color(0xFF1E1E1E),
            ),
          ),
        ),

        // Content overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Poster
                Container(
                  width: 140,
                  height: 210,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Color(0xFF2A2A2A),
                        child: Icon(Icons.movie, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),

                // Movie info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      if (movie.tagline?.isNotEmpty ?? false) ...[
                        SizedBox(height: 8),
                        Text(
                          '"${movie.tagline}"',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                      ],
                      SizedBox(height: 12),
                      _buildGenresChips(movie.genres),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildActionButton(
                            icon: Icons.play_circle_fill,
                            label: 'Bande-annonce',
                            isPrimary: true,
                            onTap: () {},
                          ),
                          _buildActionButton(
                            icon: Icons.add,
                            label: 'Ma liste',
                            isPrimary: false,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenresChips(List<Genre> genres) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres.take(4).map((genre) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            genre.name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? Color(0xFFE50914) : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(MovieDetails movie) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1E1E),
            Color(0xFF2A2A2A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.calendar_today,
                  label: 'Sortie',
                  value: movie.releaseDate?.substring(0, 4) ?? 'N/A',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.access_time,
                  label: 'Durée',
                  value: '${movie.runtime ?? 0} min',
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.star, color: Color(0xFFFFD700), size: 32),
                    SizedBox(height: 8),
                    RatingBarIndicator(
                      rating: movie.voteAverage / 2,
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: Color(0xFFFFD700)),
                      itemCount: 5,
                      itemSize: 20,
                      unratedColor: Colors.white24,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${movie.voteAverage.toStringAsFixed(1)}/10',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${movie.voteCount} votes',
                      style: TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.attach_money,
                  label: 'Budget',
                  value: '\$${(movie.budget / 1000000).toStringAsFixed(0)}M',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFFE50914), size: 28),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFFB3B3B3),
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMovieOverview(MovieDetails movie) {
    return Text(
      movie.overview,
      style: TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 15,
        height: 1.6,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Color(0xFFE50914),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCastList(List<CastMember> cast) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        itemBuilder: (context, index) {
          final actor = cast[index];
          return Container(
            width: 120,
            margin: EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFFE50914), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE50914).withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      actor.fullProfilePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Color(0xFF2A2A2A),
                        child: Icon(Icons.person, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  actor.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  actor.character ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFB3B3B3),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCrewSection(List<CrewMember> crew) {
    final directors = crew.where((p) => p.job == 'Director').take(3).toList();
    final writers = crew.where((p) => p.job == 'Writer').take(3).toList();
    final producers = crew.where((p) => p.job == 'Producer').take(3).toList();

    final camera = crew.where((p) => p.job == 'Camera').take(3).toList();
    final sound = crew.where((p) => p.job == 'Sound').take(3).toList();
    final art = crew.where((p) => p.job == 'Art').take(3).toList();
    final editing = crew.where((p) => p.job == 'Editing').take(3).toList();
    final costume_make_up = crew.where((p) => p.job == 'Costume & Make-Up').take(3).toList();
    // final visual_effects = crew.where((p) => p.job == 'Visual Effects').take(3).toList();
    // final crew = crew.where((p) => p.job == 'Crew').take(3).toList();

   /* 'Caméra': crew.where((p) => p.department == 'Camera').toList(),
      'Son': crew.where((p) => p.department == 'Sound').toList(),
      'Art': crew.where((p) => p.department == 'Art').toList(),
      'Édition': crew.where((p) => p.department == 'Editing').toList(),
      'Costume et maquillage':
          crew.where((p) => p.department == 'Costume & Make-Up').toList(),
      'Effets visuels':
          crew.where((p) => p.department == 'Visual Effects').toList(),
      'Équipe': crew.where((p) => p.department == 'Crew').toList(),*/

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (directors.isNotEmpty) _buildCrewRow('Réalisation', directors),
          if (writers.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildCrewRow('Scénario', writers),
          ],
          if (producers.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildCrewRow('Production', producers),
          ],
          if (camera.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildCrewRow('Camera', camera),
          ],
          if (sound.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildCrewRow('Son', sound),
          ],
          if (art.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildCrewRow('Art', art),
          ],
          if (editing.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildCrewRow('Édition', editing),
          ],
          if (costume_make_up.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildCrewRow('Costume et maquillage', costume_make_up),
          ],
        ],
      ),
    );
  }

  Widget _buildCrewRow(String role, List<CrewMember> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          role,
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: members.map((member) {
            return Text(
              member.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
