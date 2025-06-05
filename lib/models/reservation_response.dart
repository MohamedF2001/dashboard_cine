import 'package:dashbord_cine/models/session_model.dart';

class ReservationResponse {
  final bool success;
  final List<Reservation> reservations;

  ReservationResponse({
    required this.success,
    required this.reservations,
  });

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    return ReservationResponse(
      success: json['success'] ?? false,
      reservations: (json['reservations'] as List?)
          ?.map((item) => Reservation.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class Reservation {
  final String id;
  final Session seance;
  final User user;
  final int nombrePlaces;
  final int prixTotal;
  final String statut;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Reservation({
    required this.id,
    required this.seance,
    required this.user,
    required this.nombrePlaces,
    required this.prixTotal,
    required this.statut,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['_id'] ?? '',
      seance: Session.fromJson(json['seanceId'] ?? {}),
      user: User.fromJson(json['userId'] ?? {}),
      nombrePlaces: json['nombrePlaces'] ?? 0,
      prixTotal: json['prixTotal'] ?? 0,
      statut: json['statut'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seanceId': seance.id,
      'userId': user.id,
      'nombrePlaces': nombrePlaces,
      'prixTotal': prixTotal,
      'statut': statut,
    };
  }

  // Méthodes utilitaires
  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  String get formattedTime {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }
}


class User {
  final String id;
  final String nom;
  final String prenom;
  final String numero;
  final String password;
  final int v;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.numero,
    required this.password,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      numero: json['numero'] ?? '',
      password: json['password'] ?? '',
      v: json['__v'] ?? 0,
    );
  }

  String get fullName => '$prenom $nom';
}