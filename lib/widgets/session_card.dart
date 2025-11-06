// lib/widgets/session_card.dart
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/session_model.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SessionCard({
    Key? key,
    required this.session,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Image du film
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w200${session.imgFilm}',
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 100,
                    height: 140,
                    color: AppTheme.dividerColor,
                    child: Icon(
                      Icons.movie_rounded,
                      color: AppTheme.textSecondary,
                      size: 40,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16),

              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.film,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.access_time_rounded,
                      session.formattedTime,
                    ),
                    SizedBox(height: 6),
                    _buildInfoRow(
                      Icons.calendar_today_rounded,
                      session.formattedDate,
                    ),
                    SizedBox(height: 6),
                    _buildInfoRow(
                      Icons.room_rounded,
                      session.salle,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        _buildInfoRow(
                          Icons.event_seat_rounded,
                          '${session.placesDisponibles} places',
                        ),
                        SizedBox(width: 16),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(session.typeSeance),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            session.typeSeance,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${session.prix} FCFA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentGold,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu actions
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: AppTheme.textPrimary,
                ),
                color: AppTheme.cardColor,
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) onEdit!();
                  if (value == 'delete' && onDelete != null) onDelete!();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 20, color: AppTheme.textPrimary),
                        SizedBox(width: 12),
                        Text('Modifier', style: TextStyle(color: AppTheme.textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, size: 20, color: AppTheme.primaryRed),
                        SizedBox(width: 12),
                        Text('Supprimer', style: TextStyle(color: AppTheme.primaryRed)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppTheme.textSecondary,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
      case '3D':
        return Color(0xFF2196F3);
      case 'VIP':
        return AppTheme.accentGold;
      case 'IMAX':
        return Color(0xFF9C27B0);
      default:
        return AppTheme.primaryRed;
    }
  }
}