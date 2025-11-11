import 'package:deckmate/domain/repositories/quiz_repository.dart';
import 'package:deckmate/models/sailing_quiz.dart';

class QuizRepositoryImpl implements QuizRepository {
  late SailingQuiz _quizData;

  @override
  Future<void> loadQuizzes() async {
    try {
      _quizData = await SailingQuizLoader.loadFromAssets('assets/sailing_quiz.json');
    } catch (e) {
      throw Exception('Failed to load quizzes: $e');
    }
  }

  @override
  int? getTotalQuestions() {
    if (_quizData.quizzes.isEmpty) return null;
    return _quizData.quizzes.first.questions.length;
  }

  SailingQuiz? getQuizData() => _quizData;
}
