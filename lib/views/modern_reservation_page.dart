// lib/views/modern_reservation_page.dart
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/reservation_response.dart';
import '../services/reservation_service.dart';
import '../widgets/reservation_card.dart';

class ReservationsPagee extends StatefulWidget {
  const ReservationsPagee({Key? key}) : super(key: key);

  @override
  State<ReservationsPagee> createState() => _ReservationsPageeState();
}

class _ReservationsPageeState extends State<ReservationsPagee> {
  final ReservationService _reservationService = ReservationService();
  List<Reservation> _reservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() => _isLoading = true);

    try {
      final response = await _reservationService.getReservations();
      setState(() {
        _reservations = response.reservations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  void _showReservationDetails(Reservation reservation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Détails de la réservation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppTheme.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${reservation.seance.imgFilm}',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  reservation.seance.film,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Divider(height: 32, color: AppTheme.dividerColor),
                _buildDetailRow('Date', reservation.seance.formattedDate),
                _buildDetailRow('Heure', reservation.seance.formattedTime),
                _buildDetailRow('Salle', reservation.seance.salle),
                _buildDetailRow('Client', reservation.user.fullName),
                _buildDetailRow('Places', '${reservation.nombrePlaces}'),
                _buildDetailRow('Total', '${reservation.prixTotal} FCFA'),
                _buildDetailRow('Statut', reservation.statut),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryRed,
        ),
      )
          : _reservations.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _loadReservations,
        color: AppTheme.primaryRed,
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: _reservations.length,
          itemBuilder: (context, index) {
            return ReservationCard(
              reservation: _reservations[index],
              onTap: () => _showReservationDetails(_reservations[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.confirmation_number_outlined,
              size: 64,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Aucune réservation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Les réservations apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}