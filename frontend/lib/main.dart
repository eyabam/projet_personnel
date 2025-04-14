import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/score_history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDark') ?? false;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'CyberQuiz',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white, 
            primaryColor: Colors.blue[900],
            fontFamily: 'Poppins',
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue[900],
              foregroundColor: Colors.white,
              elevation: 2,
              titleTextStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontFamilyFallback: ['NotoColorEmoji'],
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.blue[900],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Color(0xFFF5F5F5),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontSize: 16),
            ),
            cardTheme: CardTheme(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.tealAccent[700],
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0E1621),
            primaryColor: const Color(0xFF1A2634),
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF101B26),
              foregroundColor: Colors.tealAccent,
              elevation: 2,
              titleTextStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontFamilyFallback: ['NotoColorEmoji'],
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
            cardColor: const Color(0xFF1A2634),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.tealAccent),
              labelLarge: TextStyle(color: Colors.tealAccent),
            ),
            colorScheme: ColorScheme.dark(
              primary: Colors.tealAccent,
              secondary: Colors.cyanAccent,
              background: Color(0xFF0E1621),
              error: Colors.redAccent,
            ),
          ),
          themeMode: currentMode,
          initialRoute: '/',
          routes: {
            '/': (_) => const SplashScreen(),
            '/login': (_) => const LoginScreen(),
            '/register': (_) => const RegisterScreen(),
            '/scores': (_) => const ScoreHistoryScreen(),
            '/profile': (_) => const ProfileScreen(),
          },
        );
      },
    );
  }
}
