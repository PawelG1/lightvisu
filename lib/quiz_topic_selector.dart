import 'package:flutter/material.dart';
import 'package:deckmate/models/sailing_quiz.dart';

/// Quiz Topic Selector Screen
class QuizTopicSelector extends StatelessWidget {
  final SailingQuiz quizData;
  final Function(Quiz quiz) onQuizSelected;

  const QuizTopicSelector({
    required this.quizData,
    required this.onQuizSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Quiz Topic'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quizData.quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizData.quizzes[index];
          return _buildQuizCard(context, quiz);
        },
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, Quiz quiz) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => onQuizSelected(quiz),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                quiz.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                quiz.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Question count
              Row(
                children: [
                  const Icon(Icons.quiz, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    '${quiz.questions.length} questions',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward, size: 16, color: Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
