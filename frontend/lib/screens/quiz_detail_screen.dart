// lib/screens/quiz_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/quiz.dart';

class QuizDetailScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizDetailScreen({super.key, required this.quiz});

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  String? _selectedChoice;
  bool _answered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.titre)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(widget.quiz.question, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 24),
          ...widget.quiz.choix.map((choix) {
            final isCorrect = choix == widget.quiz.bonneReponse;
            final isSelected = choix == _selectedChoice;

            Color getColor() {
              if (!_answered) return Colors.grey[300]!;
              if (isSelected && isCorrect) return Colors.green;
              if (isSelected && !isCorrect) return Colors.red;
              if (isCorrect) return Colors.green;
              return Colors.grey[300]!;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: getColor(),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _answered
                    ? null
                    : () {
                        setState(() {
                          _selectedChoice = choix;
                          _answered = true;
                        });
                      },
                child: Text(choix),
              ),
            );
          }).toList(),
          if (_answered)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _selectedChoice == widget.quiz.bonneReponse
                      ? ' Bonne réponse !'
                      : ' Mauvaise réponse.',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
