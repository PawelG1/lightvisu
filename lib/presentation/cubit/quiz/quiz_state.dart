part of 'quiz_cubit.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final int totalQuestions;

  QuizLoaded({required this.totalQuestions});
}

class QuizError extends QuizState {
  final String message;

  QuizError(this.message);
}
