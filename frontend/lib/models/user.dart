import 'package:jwt_decoder/jwt_decoder.dart';

class User {
  final int id;
  final String fullName;
  final String username;
  final String email;
  final String dateNaissance;
  final bool isAdmin;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.dateNaissance,
    required this.isAdmin,
  });

  factory User.fromToken(String token) {
    final decoded = JwtDecoder.decode(token);

    return User(
      id: decoded['id'] ?? 0,
      fullName: decoded['full_name'] ?? '',
      username: decoded['username'] ?? '',
      email: decoded['email'] ?? '',
      dateNaissance: decoded['date_naissance'] ?? '',
      isAdmin: decoded['is_admin'] == true || decoded['is_admin'] == 1,
    );
  }
}
