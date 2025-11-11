abstract class QuizRepository {
  Future<void> loadQuizzes();
  int? getTotalQuestions();
}
