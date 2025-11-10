import 'dart:convert';
import 'package:flutter/services.dart';

class SailingQuiz {
  final List<Quiz> quizzes;

  SailingQuiz({required this.quizzes});

  factory SailingQuiz.fromJson(Map<String, dynamic> json) {
    final quizzesJson = (json['quizzes'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final quizzes = quizzesJson.map((q) => Quiz.fromJson(q)).toList();

    return SailingQuiz(quizzes: quizzes);
  }
}

class Quiz {
  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final questionsJson = (json['questions'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final questions =
        questionsJson.map((q) => QuizQuestion.fromJson(q)).toList();

    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      questions: questions,
    );
  }
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List<dynamic>),
      correctAnswer: json['correct_answer'] as int,
      explanation: json['explanation'] as String,
    );
  }
}

class SailingQuizLoader {
  static Future<SailingQuiz> loadFromAssets(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    return SailingQuiz.fromJson(jsonData);
  }

  static Future<Quiz?> getQuiz(String assetPath, String quizId) async {
    final quizData = await loadFromAssets(assetPath);
    try {
      return quizData.quizzes.firstWhere((quiz) => quiz.id == quizId);
    } catch (e) {
      return null;
    }
  }

  static Future<List<String>> getAvailableQuizzes(String assetPath) async {
    final quizData = await loadFromAssets(assetPath);
    return quizData.quizzes.map((quiz) => quiz.id).toList();
  }
}
