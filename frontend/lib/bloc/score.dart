// lib/bloc/score.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/score_service.dart';
import '../models/score.dart';

// Events
abstract class ScoreEvent extends Equatable {
  const ScoreEvent();

  @override
  List<Object> get props => [];
}

class LoadScores extends ScoreEvent {}

class SaveScore extends ScoreEvent {
  final String titre;
  final String categorie;
  final int score;
  final int total;

  const SaveScore({
    required this.titre,
    required this.categorie,
    required this.score,
    required this.total,
  });

  @override
  List<Object> get props => [titre, categorie, score, total];
}

// States
abstract class ScoreState extends Equatable {
  const ScoreState();
  
  @override
  List<Object> get props => [];
}

class ScoreInitial extends ScoreState {}

class ScoreLoading extends ScoreState {}

class ScoresLoaded extends ScoreState {
  final List<Score> scores;

  const ScoresLoaded(this.scores);

  @override
  List<Object> get props => [scores];
}

class ScoreError extends ScoreState {
  final String message;

  const ScoreError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  final ScoreService scoreService;

  ScoreBloc({required this.scoreService}) : super(ScoreInitial()) {
    on<LoadScores>(_onLoadScores);
    on<SaveScore>(_onSaveScore);
  }

  Future<void> _onLoadScores(LoadScores event, Emitter<ScoreState> emit) async {
    emit(ScoreLoading());
    try {
      final scores = await scoreService.getUserScores();
      emit(ScoresLoaded(scores));
    } catch (e) {
      print('⚠️ Erreur chargement scores : ${e.toString()}');
      emit(ScoreError('Échec du chargement des scores: ${e.toString()}'));
    }
  }

  Future<void> _onSaveScore(SaveScore event, Emitter<ScoreState> emit) async {
    emit(ScoreLoading());
    try {
      await scoreService.saveScore(
        titre: event.titre,
        categorie: event.categorie,
        score: event.score,
        total: event.total,
      );
      
      // Recharger les scores après la sauvegarde
      final updatedScores = await scoreService.getUserScores();
      emit(ScoresLoaded(updatedScores));
    } catch (e) {
      print('⚠️ Erreur sauvegarde score : ${e.toString()}');
      emit(ScoreError('Échec de la sauvegarde du score: ${e.toString()}'));
    }
  }
}