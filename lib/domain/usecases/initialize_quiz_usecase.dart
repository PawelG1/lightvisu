import 'package:deckmate/domain/repositories/quiz_repository.dart';

class InitializeQuizUsecase {
  final QuizRepository repository;

  InitializeQuizUsecase({required this.repository});

  Future<void> call() async {
    await repository.loadQuizzes();
  }
}
