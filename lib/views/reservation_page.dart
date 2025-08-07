import 'package:flutter/material.dart';
import '../models/reservation_response.dart';
import '../services/reservation_service.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final ReservationService _reservationService = ReservationService();
  List<Reservation> _reservations = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _reservationService.getReservations();
      setState(() {
        _reservations = response.reservations;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load reservations: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showReservationDetails(Reservation reservation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reservation.seance.film,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${reservation.seance.imgFilm}',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(child: Icon(Icons.movie, size: 50)),
                      ),
                ),
              ),
              SizedBox(height: 16),
              _buildDetailRow('Date', reservation.seance.formattedDate),
              _buildDetailRow('Time', reservation.seance.formattedTime),
              _buildDetailRow('Room', reservation.seance.salle),
              _buildDetailRow('Type', reservation.seance.typeSeance),
              Divider(height: 24),
              _buildDetailRow('Reservation ID', reservation.id),
              _buildDetailRow('Status', reservation.statut),
              _buildDetailRow('Number of seats', '${reservation.nombrePlaces}'),
              _buildDetailRow('Total price', '${reservation.prixTotal} €'),
              _buildDetailRow(
                'Booked on',
                '${reservation.formattedDate} at ${reservation.formattedTime}',
              ),
              SizedBox(height: 24),
              if (reservation.statut.toLowerCase() == 'confirmée')
                ElevatedButton(
                  //onPressed: () => _cancelReservation(reservation.id),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Cancel Reservation',
                  style: TextStyle(
                    color: Colors.white
                  ),),
                ),
            ],
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
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  /*Future<void> _cancelReservation(String reservationId) async {
    try {
      await _reservationService.deleteReservation(reservationId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation cancelled successfully')),
      );
      _loadReservations();
      Navigator.pop(context); // Close the bottom sheet
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel reservation: $e')),
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.5),
        centerTitle: true,
        title: Text('Les Réservations', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadReservations,
          ),
        ],
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
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _reservations.isEmpty
                ? Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_creation_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Pas de réservations trouvées",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        /*Text(
                 'Book your first movie session!',
                 style: TextStyle(color: Colors.white, fontSize: 16),
               ),*/
                      ],
                    ),
                  ),
                )
                : RefreshIndicator(
                  onRefresh: _loadReservations,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: _reservations.length,
                      itemBuilder: (context, index) {
                        final reservation = _reservations[index];
                        return Card(
                          elevation: 0.5,
                          color: Colors.transparent,
                          margin: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: InkWell(
                            onTap: () => _showReservationDetails(reservation),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w200${reservation.seance.imgFilm}',
                                      width: 80,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 80,
                                                height: 120,
                                                color: Colors.grey[200],
                                                child: Icon(
                                                  Icons.movie,
                                                  size: 40,
                                                ),
                                              ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reservation.seance.film,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${reservation.seance.formattedDate} • ${reservation.seance.formattedTime}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Salle: ${reservation.seance.salle}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "Réservation de ${reservation.user.nom}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Chip(
                                              label: Text(
                                                reservation.statut,
                                                style: TextStyle(
                                                  color:
                                                      reservation.statut
                                                                  .toLowerCase() ==
                                                              'confirmée'
                                                          ? Colors.green
                                                          : Colors.orange,
                                                ),
                                              ),
                                              backgroundColor:
                                                  reservation.statut
                                                              .toLowerCase() ==
                                                          'confirmée'
                                                      ? Colors.green[50]
                                                      : Colors.orange[50],
                                            ),
                                            Text(
                                              '${reservation.nombrePlaces} place${reservation.nombrePlaces > 1 ? 's' : ''}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
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
                      },
                    ),
                  ),
                ),
      ),
    );
  }
}
