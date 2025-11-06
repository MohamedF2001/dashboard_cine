// lib/widgets/modern_movie_card.dart
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/movie_response.dart';

class ModernMovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const ModernMovieCard({
    Key? key,
    required this.movie,
    this.onTap,
  }) : super(key: key);

  @override
  State<ModernMovieCard> createState() => _ModernMovieCardState();
}

class _ModernMovieCardState extends State<ModernMovieCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isHovered ? AppTheme.hoverShadow : AppTheme.cardShadow,
            ),
            child: Stack(
              children: [
                // Image principale
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.movie.fullPosterUrl,
                    fit: BoxFit.cover,
                    height: 280,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      height: 280,
                      color: AppTheme.cardColor,
                      child: Center(
                        child: Icon(
                          Icons.movie_rounded,
                          size: 60,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),

                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),

                // Informations du film
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.movie.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppTheme.accentGold,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.movie.voteAverage.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.accentGold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.calendar_today_rounded,
                              color: AppTheme.textSecondary,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.movie.releaseDate?.substring(0, 4) ?? 'N/A',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Badge hover
                if (_isHovered)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryRed,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



