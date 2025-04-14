import '../models/quiz.dart';
import '../models/score.dart';

part of 'quiz_bloc.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<Quiz> quizzes;
  final List<Score> scores;

  QuizLoaded({
    required this.quizzes,
    required this.scores,
  });
}

class QuizError extends QuizState {
  final String message;
  QuizError(this.message);
}