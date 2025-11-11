import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deckmate/domain/usecases/initialize_quiz_usecase.dart';
import 'package:deckmate/data/repositories/quiz_repository_impl.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final InitializeQuizUsecase initializeUsecase;
  final QuizRepositoryImpl repository;

  QuizCubit({
    required this.initializeUsecase,
    required this.repository,
  }) : super(QuizInitial());

  Future<void> initialize() async {
    try {
      emit(QuizLoading());
      await initializeUsecase();
      
      final totalQuestions = repository.getTotalQuestions() ?? 0;
      emit(QuizLoaded(totalQuestions: totalQuestions));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }
}
