// frontend/lib/widgets/quiz_card.dart
QuizCard(
  question: "Ce mail est-il un phishing ?",
  imagePath: "assets/phishing_email.png",
  onAnswer: (bool answer) {
    if (answer == quiz.correctAnswer) {
      setState(() => score++);
    }
  },
)