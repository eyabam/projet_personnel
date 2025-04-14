import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/quiz_bloc.dart';
import '../services/quiz_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  Future<void> login() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/login'), // Your API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 🔐 Save the token and admin status
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setBool('isAdmin', data['user']['isAdmin']);  // Save admin status

        // 🔁 Retrieve the username
        final String username = data['user']['username'];

        setState(() => message = data['message']);

        // 🧭 Navigate to HomeScreen with Bloc and username
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => QuizBloc(QuizService())..add(LoadQuizzes()),
              child: HomeScreen(username: username),  // Pass the username to HomeScreen
            ),
          ),
        );
      } else {
        setState(() => message = data['error'] ?? 'Erreur');
      }
    } catch (e) {
      setState(() => message = 'Erreur de connexion au serveur.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text('Se connecter'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text("Pas encore de compte ? S’inscrire"),
            ),
            const SizedBox(height: 12),
            if (message.isNotEmpty)
              Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
