
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

class SessionResponse {
  final bool success;
  final List<Session> seances;

  SessionResponse({
    required this.success,
    required this.seances,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      success: json['success'] ?? false,
      seances: (json['seance'] as List?)
          ?.map((item) => Session.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class CreateSessionResponse {
  final bool success;
  final String msg;
  final Session seance;

  CreateSessionResponse({
    required this.success,
    required this.msg,
    required this.seance,
  });

  factory CreateSessionResponse.fromJson(Map<String, dynamic> json) {
    return CreateSessionResponse(
      success: json['success'] ?? false,
      msg: json['msg'] ?? '',
      seance: Session.fromJson(json['seance']),
    );
  }
}


class Session {
  final String id;
  final int filmId;
  final String film;
  final String imgFilm;
  final DateTime horaire;
  final DateTime date;
  final String salle;
  final String typeSeance;
  final int prix;
  final int placesDisponibles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Session({
    required this.id,
    required this.filmId,
    required this.film,
    required this.imgFilm,
    required this.horaire,
    required this.date,
    required this.salle,
    required this.typeSeance,
    required this.prix,
    required this.placesDisponibles,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['_id'] ?? '',
      filmId: json['filmId'] is int ? json['filmId'] : int.tryParse(json['filmId'] ?? '0') ?? 0,
      film: json['film'] ?? '',
      imgFilm: json['img_film'] ?? '',
      horaire: DateTime.parse(json['horaire'] ?? DateTime.now().toIso8601String()),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      salle: json['salle'] ?? '',
      typeSeance: json['typeSeance'] ?? 'Normal',
      //prix: (json['prix'] as num?)?.toDouble() ?? 0.0,
      prix: json['prix'] ?? 0,
      placesDisponibles: json['placesDisponibles'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filmId': filmId,
      'film': film,
      'img_film': imgFilm,
      'horaire': horaire.toIso8601String(),
      'date': date.toIso8601String(),
      'salle': salle,
      'typeSeance': typeSeance,
      'prix': prix,
      'placesDisponibles': placesDisponibles,
    };
  }

  // Vous pourriez ajouter des méthodes utilitaires comme :
  /*String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedTime {
    return '${horaire.hour}:${horaire.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateTime {
    return '$formattedDate à $formattedTime';
  }

  String get dayOfWeek {
    initializeDateFormatting('fr', ''); // Initialise les données de localisation française
    return DateFormat('EEEE', 'fr').format(date).capitalize();
  }

  // Version plus complète avec date + jour
  String get formattedDateWithDay {
    initializeDateFormatting('fr', '');
    return '${dayOfWeek} ${date.day}/${date.month}/${date.year}';
  }*/

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedTime {
    return '${horaire.hour}:${horaire.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateTime {
    return '$formattedDate à $formattedTime';
  }

  String get dayOfWeek {
    return DateFormat('EEEE', 'fr').format(date).capitalize();
  }

  String get formattedDateWithDay {
    return '$dayOfWeek ${date.day}/${date.month}/${date.year}';
  }

  String get formattedDateWithDayY {
    initializeDateFormatting('fr', '');
    return '${dayOfWeek} ${date.day}/${date.month}/${date.year}';
  }

}

class CreateSession {
  final String id;
  final int filmId;
  final String film;
  final String imgFilm;
  final DateTime horaire;
  final DateTime date;
  final String salle;
  final String typeSeance;
  final int prix;
  final int placesDisponibles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CreateSession({
    required this.id,
    required this.filmId,
    required this.film,
    required this.imgFilm,
    required this.horaire,
    required this.date,
    required this.salle,
    required this.typeSeance,
    required this.prix,
    required this.placesDisponibles,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CreateSession.fromJson(Map<String, dynamic> json) {
    return CreateSession(
      id: json['_id'] ?? '',
      filmId: json['filmId'] is int ? json['filmId'] : int.tryParse(json['filmId'] ?? '0') ?? 0,
      film: json['film'] ?? '',
      imgFilm: json['img_film'] ?? '',
      horaire: DateTime.parse(json['horaire'] ?? DateTime.now().toIso8601String()),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      salle: json['salle'] ?? '',
      typeSeance: json['typeSeance'] ?? 'Normal',
      //prix: (json['prix'] as num?)?.toDouble() ?? 0.0,
      prix: json['prix'] ?? 0,
      placesDisponibles: json['placesDisponibles'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filmId': filmId,
      'film': film,
      'img_film': imgFilm,
      'horaire': horaire.toIso8601String(),
      'date': date.toIso8601String(),
      'salle': salle,
      'typeSeance': typeSeance,
      'prix': prix,
      'placesDisponibles': placesDisponibles,
    };
  }

  // Vous pourriez ajouter des méthodes utilitaires comme :
  /*String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedTime {
    return '${horaire.hour}:${horaire.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateTime {
    return '$formattedDate à $formattedTime';
  }

  String get dayOfWeek {
    initializeDateFormatting('fr', ''); // Initialise les données de localisation française
    return DateFormat('EEEE', 'fr').format(date).capitalize();
  }

  // Version plus complète avec date + jour
  String get formattedDateWithDay {
    initializeDateFormatting('fr', '');
    return '${dayOfWeek} ${date.day}/${date.month}/${date.year}';
  }*/

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedTime {
    return '${horaire.hour}:${horaire.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateTime {
    return '$formattedDate à $formattedTime';
  }

  String get dayOfWeek {
    return DateFormat('EEEE', 'fr').format(date).capitalize();
  }

  String get formattedDateWithDay {
    return '$dayOfWeek ${date.day}/${date.month}/${date.year}';
  }

  String get formattedDateWithDayY {
    initializeDateFormatting('fr', '');
    return '${dayOfWeek} ${date.day}/${date.month}/${date.year}';
  }

}

// Extension pour capitaliser la première lettre d'une String
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}