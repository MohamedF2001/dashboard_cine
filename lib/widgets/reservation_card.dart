// lib/widgets/reservation_card.dart
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/reservation_response.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback? onTap;

  const ReservationCard({
    Key? key,
    required this.reservation,
    this.onTap,
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
                  'https://image.tmdb.org/t/p/w200${reservation.seance.imgFilm}',
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 120,
                    color: AppTheme.dividerColor,
                    child: Icon(
                      Icons.movie_rounded,
                      color: AppTheme.textSecondary,
                      size: 30,
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
                      reservation.seance.film,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${reservation.seance.formattedDate} • ${reservation.seance.formattedTime}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Salle: ${reservation.seance.salle}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Client: ${reservation.user.fullName}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(reservation.statut),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            reservation.statut.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          '${reservation.nombrePlaces} place${reservation.nombrePlaces > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentGold,
                          ),
                        ),
                        Text(
                          '${reservation.prixTotal} FCFA',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryRed,
                          ),
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
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmée':
        return Color(0xFF4CAF50);
      case 'en attente':
        return Color(0xFFFFA726);
      case 'annulée':
        return Color(0xFFEF5350);
      default:
        return AppTheme.textSecondary;
    }
  }
}