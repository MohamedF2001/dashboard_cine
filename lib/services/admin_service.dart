import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminService {
  static const String baseUrl = 'http://localhost:3000';
  static const String onlineUrl = 'https://cinema-api-chi.vercel.app';

  static Future<Map<String, dynamic>> login(String pseudo, String password) async {
    final url = Uri.parse('$onlineUrl/adminlogin');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pseudo': pseudo, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'success': true, 'token': data['token']};
    } else {
      final error = jsonDecode(response.body);
      return {'success': false, 'msg': error['msg'] ?? 'Erreur inconnue'};
    }
  }
}
