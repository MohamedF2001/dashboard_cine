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
  //final AuthService _authService = AuthService();

  int _nombrePlaces = 1;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final prixTotal = _nombrePlaces * widget.seance.prix;

    return Scaffold(
      appBar: AppBar(title: Text('Réserver ${widget.seance.film}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Affiche les détails de la séance
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.seance.film,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text('Date: ${widget.seance.formattedDate}'),
                      Text('Heure: ${widget.seance.formattedTime}'),
                      Text('Salle: ${widget.seance.salle}'),
                      Text('Type: ${widget.seance.typeSeance}'),
                      const SizedBox(height: 8),
                      Text(
                        'Prix unitaire: ${widget.seance.prix} €',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Places disponibles: ${widget.seance.placesDisponibles}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sélecteur de nombre de places
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre de places',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: _nombrePlaces.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nombre';
                  }
                  final nb = int.tryParse(value);
                  if (nb == null || nb <= 0) {
                    return 'Nombre invalide';
                  }
                  if (nb > widget.seance.placesDisponibles) {
                    return 'Pas assez de places disponibles';
                  }
                  return null;
                },
                onChanged: (value) {
                  final nb = int.tryParse(value) ?? 1;
                  setState(() {
                    _nombrePlaces = nb;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Affichage du prix total
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '$prixTotal €',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Bouton de réservation
              ElevatedButton(
                onPressed: _isLoading ? null : _submitReservation,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Confirmer la réservation',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
              const SizedBox(height: 16),

              // Affichage des erreurs
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReservation() async {
    //final AuthService _authService = AuthService();
    if (!_formKey.currentState!.validate()) return;
    final userId = await _authService.getCurrentUserId();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Vérifier que l'utilisateur est connecté
      /*final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        throw Exception('Vous devez être connecté pour réserver');
      }*/

      // Créer la réservation
      await _reservationService.createReservation(
        userId: userId!,
        seanceId: widget.seance.id,
        //nombrePlaces: _nombrePlaces,
        numeroSiege: "3",
        prixTotal: _nombrePlaces * widget.seance.prix,
      );

      // Afficher un message de succès et retourner
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Réservation effectuée avec succès!')),
      );
      Navigator.pop(context, true); // Retour avec succès
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
