import 'package:bloc/bloc.dart';
import '../models/quiz.dart';
import '../models/score.dart';
import '../services/quiz_service.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizService quizService;

  QuizBloc(this.quizService) : super(QuizInitial()) {
    on<LoadQuizzes>(_onLoadQuizzes);
  }

  void _onLoadQuizzes(LoadQuizzes event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    try {
      final quizzes = await quizService.fetchQuizzes();
      List<Score> scores = [];
      try {
        scores = await quizService.fetchScores(); // On essaye de charger les scores
      } catch (e) {
        print("⚠️ Erreur chargement scores : $e");
      }

      emit(QuizLoaded(quizzes: quizzes, scores: scores));
    } catch (e) {
      emit(QuizError("Erreur lors du chargement des quizzes : $e"));
    }
  }
}
