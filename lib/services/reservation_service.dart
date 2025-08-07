import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reservation_response.dart';
import 'auth_service.dart';

class ReservationService {
  static const String _localUrl =
      'http://localhost:3000'; // Remplacez par votre URL
  static const String onlineUrl = 'https://cinema-api-chi.vercel.app';
  final AuthService _authService = AuthService();

  /*Future<ReservationResponse> createReservation({
    required String seanceId,
    required int nombrePlaces,
    required int prixTotal,
    String statut = 'confirmée',
  }) async {
    try {
      final token = await _authService.getToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/reservations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'seanceId': seanceId,
          'nombrePlaces': nombrePlaces,
          'prixTotal': prixTotal,
          'statut': statut,
        }),
      );

      if (response.statusCode == 201) {
        return ReservationResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create reservation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create reservation: $e');
    }
  }*/

  Future<Reservation> createReservation({
    required String seanceId,
    required String userId,
    required int prixTotal,
    required String numeroSiege,
    String statut = 'confirmée',
  }) async {
    try {
      // Récupérer le token JWT
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      // Préparer le corps de la requête
      final requestBody = json.encode({
        'seanceId': seanceId,
        'userId': userId,
        'prixTotal': prixTotal,
        'numeroSiege': numeroSiege,
        'statut': statut,
      });

      // Envoyer la requête POST
      final response = await http.post(
        Uri.parse('$onlineUrl/reservations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      // Traiter la réponse
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return Reservation.fromJson(responseData['reservation']);
      } else {
        throw Exception(
          'Échec de la création de réservation: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erreur lors de la création de réservation: $e');
    }
  }

  Future<ReservationResponse> getReservations() async {
    try {
      //final token = await _authService.getToken();
      final response = await http.get(Uri.parse('$onlineUrl/reservations'));

      if (response.statusCode == 200) {
        return ReservationResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load reservations: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load reservations: $e');
    }
  }

  Future<ReservationResponse> getReservationsByUser(String userId) async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('$onlineUrl/reservations/user/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ReservationResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user reservations: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load user reservations: $e');
    }
  }

  Future<Reservation> updateReservation({
    required String reservationId,
    int? nombrePlaces,
    int? prixTotal,
    String? statut,
  }) async {
    try {
      final token = await _authService.getToken();
      final response = await http.put(
        Uri.parse('$onlineUrl/reservations/$reservationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          if (nombrePlaces != null) 'nombrePlaces': nombrePlaces,
          if (prixTotal != null) 'prixTotal': prixTotal,
          if (statut != null) 'statut': statut,
        }),
      );

      if (response.statusCode == 200) {
        return Reservation.fromJson(json.decode(response.body)['reservation']);
      } else {
        throw Exception('Failed to update reservation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update reservation: $e');
    }
  }

  Future<void> deleteReservation(String reservationId) async {
    try {
      //final token = await _authService.getToken();
      final response = await http.delete(
        Uri.parse('$onlineUrl/reservations/$reservationId'),
        //headers: {
        //  'Authorization': 'Bearer $token',
        //},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete reservation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete reservation: $e');
    }
  }

  Future<bool> canModifyReservation(String reservationId) async {
    try {
      //final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('$onlineUrl/reservations/$reservationId/check'),
        //headers: {
        //  'Authorization': 'Bearer $token',
        //},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['canModify'];
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
