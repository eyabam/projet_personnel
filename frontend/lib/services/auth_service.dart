// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://localhost:3000"; // change selon ton IP ou serveur

  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String username,
    required String dateNaissance,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'username': username,
        'date_naissance': dateNaissance,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'message': 'Inscription réussie'};
    } else {
      final data = jsonDecode(response.body);
      return {'success': false, 'error': data['error'] ?? 'Erreur inconnue'};
    }
  }
}
