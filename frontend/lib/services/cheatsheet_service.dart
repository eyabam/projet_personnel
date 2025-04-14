import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cheatsheet.dart';

class CheatsheetService {
  final String baseUrl = 'http://localhost:3000/api/cheatsheets';

  Future<List<Cheatsheet>> fetchCheatsheets() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Cheatsheet.fromJson(e)).toList();
    } else {
      throw Exception('Erreur chargement des fiches');
    }
  }
}
