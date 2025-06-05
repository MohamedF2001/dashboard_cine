class AuthResponse {
  final bool success;
  final String token;
  final UserAuthInfo? user; // Optionnel si vous voulez inclure les infos utilisateur

  AuthResponse({
    required this.success,
    required this.token,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      token: json['token'] ?? '',
      user: json['user'] != null ? UserAuthInfo.fromJson(json['userId']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'token': token,
    if (user != null) 'user': user!.toJson(),
  };
}

class UserAuthInfo {
  final String id;
  final String nom;
  final String prenom;
  final String numero;

  UserAuthInfo({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.numero,
  });

  factory UserAuthInfo.fromJson(Map<String, dynamic> json) {
    return UserAuthInfo(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      numero: json['numero'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'numero': numero,
  };

  String get fullName => '$prenom $nom';
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