import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:frontend/main.dart'; // pour accéder à themeNotifier

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final userData = {
      'fullName': _fullNameController.text,
      'username': _usernameController.text,
      'dateNaissance': _dobController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    print("👉 Données envoyées pour inscription : $userData");

    try {
      await AuthService().registerUser(
        fullName: userData['fullName']!,
        username: userData['username']!,
        dateNaissance: userData['dateNaissance']!,
        email: userData['email']!,
        password: userData['password']!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription réussie !')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () async {
              final newMode = themeNotifier.value == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
              themeNotifier.value = newMode;
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isDark', newMode == ThemeMode.dark);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: "Nom complet"),
                validator: (value) =>
                    value!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _usernameController,
                decoration:
                    const InputDecoration(labelText: "Nom d'utilisateur"),
                validator: (value) =>
                    value!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Date de naissance",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
                validator: (value) =>
                    value!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Champ obligatoire";
                  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                  return emailRegex.hasMatch(value)
                      ? null
                      : "Email invalide";
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Champ obligatoire";
                  if (value.length < 8) return "Au moins 8 caractères";
                  if (!RegExp(r'[A-Z]').hasMatch(value)) return "Une majuscule requise";
                  if (!RegExp(r'[a-z]').hasMatch(value)) return "Une minuscule requise";
                  if (!RegExp(r'[0-9]').hasMatch(value)) return "Un chiffre requis";
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirmer le mot de passe",
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Champ obligatoire";
                  if (value != _passwordController.text) return "Les mots de passe ne correspondent pas";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
