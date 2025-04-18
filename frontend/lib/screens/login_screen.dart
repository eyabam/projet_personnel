import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart'; // Importé à la place de home_screen.dart
import 'register_screen.dart';
import '../bloc/quiz_bloc.dart';
import '../services/quiz_service.dart';
import '../bloc/score.dart';
import '../services/score_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';  // Pour afficher les messages

  // Fonction pour gérer la logique de connexion
  Future<void> login() async {
    try {
      // Affichage des informations de débogage
      print('Tentative de connexion avec: ${emailController.text}');
      
      // Requête POST API pour la connexion
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/login'), // URL pour émulateur Android
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      print('Réponse du serveur: ${response.body}');
      print('Statut: ${response.statusCode}');

      final data = jsonDecode(response.body);

      // Vérification si la connexion a réussi
      if (response.statusCode == 200) {
        // Sauvegarde du token et du statut admin
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setBool('isAdmin', data['user']['is_admin'] == 1);

        // Récupération du nom d'utilisateur
        final String username = data['user']['username'];

        setState(() => message = data['message']);

        // Navigation vers le Dashboard au lieu de HomeScreen
        // Utilisation de la route nommée '/home' au lieu de la navigation avec MaterialPageRoute
        Navigator.pushReplacementNamed(context, '/home');
        
        // Alternativement, si vous préférez utiliser MaterialPageRoute, voici le code équivalent :
        /*
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => QuizBloc(
                    QuizService(),
                  ),
                ),
                BlocProvider(
                  create: (_) => ScoreBloc(
                    scoreService: ScoreService(),
                  ),
                ),
              ],
              child: DashboardScreen(), // Utiliser DashboardScreen au lieu de HomeScreen
            ),
          ),
        );
        */
      } else {
        // Gestion des erreurs renvoyées par le serveur
        setState(() => message = data['error'] ?? 'Erreur inconnue');
      }
    } catch (e) {
      // Capture et affichage des erreurs détaillées
      print('Erreur détaillée: $e');
      setState(() => message = 'Erreur de connexion au serveur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: Colors.blue, // AppBar background color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            // Logo or app image (optional)
            const Icon(
              Icons.quiz,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              'Quiz App',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            // Email input field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Password input field
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            // Login button
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'SE CONNECTER',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            // Redirect to registration page
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text(
                "Pas encore de compte ? S'inscrire",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            // Show message if there is an error or success
            if (message.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                color: message.contains('Erreur') ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                child: Text(
                  message,
                  style: TextStyle(color: message.contains('Erreur') ? Colors.red : Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Libérer les contrôleurs lorsqu'ils ne sont plus nécessaires
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}