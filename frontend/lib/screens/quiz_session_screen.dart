import 'dart:async';
import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../services/score_service.dart';

class QuizSessionScreen extends StatefulWidget {
  final List<Quiz> quizzes;

  const QuizSessionScreen({super.key, required this.quizzes});

  @override
  State<QuizSessionScreen> createState() => _QuizSessionScreenState();
}

class _QuizSessionScreenState extends State<QuizSessionScreen> {
  int currentIndex = 0;
  int score = 0;
  bool answered = false;
  String? selectedChoice;
  int remainingTime = 10;
  Timer? questionTimer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    questionTimer?.cancel();
    remainingTime = 10;
    questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime == 0) {
        timer.cancel();
        handleTimeOut();
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  void handleTimeOut() {
    setState(() {
      answered = true;
      selectedChoice = null;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex < widget.quizzes.length - 1) {
        setState(() {
          currentIndex++;
          answered = false;
          selectedChoice = null;
        });
        startTimer();
      } else {
        endQuiz();
      }
    });
  }

  void handleAnswer(String choice) {
    if (answered) return;

    questionTimer?.cancel();

    final isCorrect = choice == widget.quizzes[currentIndex].bonneReponse;

    setState(() {
      selectedChoice = choice;
      answered = true;
      if (isCorrect) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex < widget.quizzes.length - 1) {
        setState(() {
          currentIndex++;
          answered = false;
          selectedChoice = null;
        });
        startTimer();
      } else {
        endQuiz();
      }
    });
  }

  void endQuiz() async {
    try {
      await ScoreService().saveScore(
        titre: widget.quizzes.first.titre,
        categorie: widget.quizzes.first.categorie,
        score: score,
        total: widget.quizzes.length,
      );
    } catch (e) {
      debugPrint("Erreur enregistrement score : $e");
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Fin du quiz'),
        content: Text('Ton score : $score / ${widget.quizzes.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    questionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.quizzes[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        backgroundColor: Colors.blue, // Custom AppBar color
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question number display
            Text(
              'Question ${currentIndex + 1}/${widget.quizzes.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Timer and progress bar
            LinearProgressIndicator(
              value: remainingTime / 10,
              minHeight: 10,
              color: remainingTime <= 3 ? Colors.red : Colors.blue,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 12),
            Text(
              'Temps restant : $remainingTime s',
              style: TextStyle(
                fontSize: 16,
                color: remainingTime <= 3 ? Colors.red : Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            // Question text
            Text(quiz.question, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),

            // Answer choices
            ...quiz.choix.map((c) {
              final isCorrect = c == quiz.bonneReponse;
              final isSelected = c == selectedChoice;

              Color getBackgroundColor() {
                if (!answered) return Colors.grey[300]!; // Default color if not answered
                if (isSelected && isCorrect) return Colors.green; // Correct answer
                if (isSelected && !isCorrect) return Colors.red; // Incorrect answer
                if (isCorrect) return Colors.green; // Correct answer without selection
                return Colors.grey[300]!; // Default color
              }

              Icon? getFeedbackIcon() {
                if (!answered) return null;
                if (isCorrect) {
                  return const Icon(Icons.check_circle, color: Colors.white, size: 24);
                } else if (isSelected) {
                  return const Icon(Icons.cancel, color: Colors.white, size: 24);
                }
                return null;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getBackgroundColor(),
                    minimumSize: const Size(double.infinity, 50), // Full width buttons
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: answered ? null : () => handleAnswer(c),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          c,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      if (getFeedbackIcon() != null) getFeedbackIcon()!, // Show the feedback icon
                    ],
                  ),
                ),
              );
            }).toList(),

            // Button to exit quiz
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Quitter le quiz"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
