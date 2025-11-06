// ===================================
// FICHIER 3: lib/views/modern_create_reservation_page.dart
// Remplace create_reservation_page.dart
// ===================================
import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../services/auth_service.dart';
import '../services/reservation_service.dart';

class CreateReservationPage extends StatefulWidget {
  final Session seance;

  const CreateReservationPage({super.key, required this.seance});

  @override
  _CreateReservationPageState createState() => _CreateReservationPageState();
}

class _CreateReservationPageState extends State<CreateReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final ReservationService _reservationService = ReservationService();
  final AuthService _authService = AuthService();

  int _nombrePlaces = 1;
  bool _isLoading = false;
  String? _errorMessage;
  List<String> _selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    final prixTotal = _nombrePlaces * widget.seance.prix;

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        title: Text(
          'Réserver ${widget.seance.film}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Movie Header
            _buildMovieHeader(),

            // Booking Form
            Padding(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Informations de la séance'),
                    SizedBox(height: 16),
                    _buildSessionInfo(),
                    SizedBox(height: 24),

                    _buildSectionTitle('Nombre de places'),
                    SizedBox(height: 16),
                    _buildSeatSelector(),
                    SizedBox(height: 24),

                    _buildPriceSummary(prixTotal),
                    SizedBox(height: 24),

                    _buildSubmitButton(prixTotal),

                    if (_errorMessage != null) ...[
                      SizedBox(height: 16),
                      _buildErrorMessage(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://image.tmdb.org/t/p/w500${widget.seance.imgFilm}',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Color(0xFF121212),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              widget.seance.film,
              style: TextStyle(
                fontSize: 24,
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
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Color(0xFFE50914),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionInfo() {
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
          _buildInfoRow(
            Icons.calendar_today,
            'Date',
            widget.seance.formattedDate,
          ),
          SizedBox(height: 12),
          _buildInfoRow(
            Icons.access_time,
            'Heure',
            widget.seance.formattedTime,
          ),
          SizedBox(height: 12),
          _buildInfoRow(
            Icons.room,
            'Salle',
            widget.seance.salle,
          ),
          SizedBox(height: 12),
          _buildInfoRow(
            Icons.event_seat,
            'Places disponibles',
            '${widget.seance.placesDisponibles}',
          ),
          SizedBox(height: 12),
          _buildInfoRow(
            Icons.local_activity,
            'Type',
            widget.seance.typeSeance,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFE50914).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFFE50914), size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeatSelector() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF333333)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nombre de places',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _buildCounterButton(
                    icon: Icons.remove,
                    onPressed: _nombrePlaces > 1
                        ? () => setState(() => _nombrePlaces--)
                        : null,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFE50914),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$_nombrePlaces',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildCounterButton(
                    icon: Icons.add,
                    onPressed: _nombrePlaces < widget.seance.placesDisponibles
                        ? () => setState(() => _nombrePlaces++)
                        : null,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: _nombrePlaces / widget.seance.placesDisponibles,
            backgroundColor: Color(0xFF333333),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
          ),
          SizedBox(height: 8),
          Text(
            'Maximum: ${widget.seance.placesDisponibles} places',
            style: TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: onPressed != null ? Color(0xFF2A2A2A) : Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: onPressed != null ? Color(0xFF333333) : Color(0xFF2A2A2A),
        ),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: onPressed != null ? Colors.white : Color(0xFF666666),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildPriceSummary(int prixTotal) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE50914).withOpacity(0.1),
            Color(0xFFFFD700).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFE50914).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prix unitaire',
                style: TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${widget.seance.prix} FCFA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Container(
            width: 2,
            height: 40,
            color: Color(0xFF333333),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'TOTAL',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '$prixTotal FCFA',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(int prixTotal) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitReservation,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE50914),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number, size: 24),
            SizedBox(width: 12),
            Text(
              'Confirmer la réservation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE50914).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE50914)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Color(0xFFE50914)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Color(0xFFE50914)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReservation() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = await _authService.getCurrentUserId();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _reservationService.createReservation(
        userId: userId!,
        seanceId: widget.seance.id,
        numeroSiege: "A${_nombrePlaces}",
        prixTotal: _nombrePlaces * widget.seance.prix,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Réservation effectuée avec succès!'),
            ],
          ),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}