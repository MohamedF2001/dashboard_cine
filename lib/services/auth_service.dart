import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthResponse {
  final bool success;
  final String token;

  AuthResponse({required this.success, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      token: json['token'] ?? '',
    );
  }
}

class AuthService {
  static const String onlineUr = 'http://localhost:3000'; // Remplacez par votre URL
  static const String onlineUrl = 'https://cinema-api-chi.vercel.app';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<AuthResponse> login({
    required String nom,
    required String prenom,
    required String numero,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$onlineUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nom': nom,
          'prenom': prenom,
          'numero': numero,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(json.decode(response.body));

        // Stocker le token sécurisé
        await _storage.write(key: 'auth_token', value: authResponse.token);

        return authResponse;
      } else {
        throw Exception('Échec de la connexion: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<Map<String, dynamic>?> getTokenPayload() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));

      return json.decode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getCurrentUserId() async {
    final payload = await getTokenPayload();
    return payload?['id']?.toString();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;

    final payload = await getTokenPayload();
    if (payload == null) return false;

    final exp = payload['exp'] as int?;
    if (exp == null) return false;

    // Vérifier si le token est expiré
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isBefore(expiryDate);
  }
}