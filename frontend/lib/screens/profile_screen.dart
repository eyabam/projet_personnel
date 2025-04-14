import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<User?> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null ? User.fromToken(token) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Profil")),
      body: FutureBuilder<User?>(
        future: _loadUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Impossible de charger l'utilisateur."));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Icon(Icons.account_circle, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text("Nom complet"),
                  subtitle: Text(user.fullName),
                ),
                ListTile(
                  title: const Text("Nom d'utilisateur"),
                  subtitle: Text(user.username),
                ),
                ListTile(
                  title: const Text("Email"),
                  subtitle: Text(user.email),
                ),
                ListTile(
                  title: const Text("Date de naissance"),
                  subtitle: Text(
                    user.dateNaissance.isNotEmpty
                        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(user.dateNaissance))
                        : 'Non spécifiée',
                  ),
                ),
                ListTile(
                  title: const Text("Rôle"),
                  subtitle: Text(user.isAdmin ? "Administrateur" : "Utilisateur"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
