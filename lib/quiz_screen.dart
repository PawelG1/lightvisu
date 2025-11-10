import 'package:flutter/material.dart';
import 'package:lightvisu/models/sailing_quiz.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  SailingQuiz? quizData;
  Quiz? selectedQuiz;
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  int score = 0;
  bool showExplanation = false;
  bool quizComplete = false;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    try {
      final quiz = await SailingQuizLoader.loadFromAssets('assets/sailing_quiz.json');
      setState(() {
        quizData = quiz;
        if (quiz.quizzes.isNotEmpty) {
          selectedQuiz = quiz.quizzes.first;
        }
      });
    } catch (e) {
      print('Error loading quiz: $e');
    }
  }

  void _answerQuestion(int answerIndex) {
    if (selectedAnswer != null) return; // Already answered

    setState(() {
      selectedAnswer = answerIndex;
      showExplanation = true;
      
      if (answerIndex == currentQuestion.correctAnswer) {
        score++;
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < selectedQuiz!.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        showExplanation = false;
      });
    } else {
      setState(() {
        quizComplete = true;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedAnswer = null;
      score = 0;
      showExplanation = false;
      quizComplete = false;
    });
  }

  QuizQuestion get currentQuestion => selectedQuiz!.questions[currentQuestionIndex];

  @override
  Widget build(BuildContext context) {
    if (selectedQuiz == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Sailing Quiz')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (quizComplete) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz Complete')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quiz Complete!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Your Score: $score / ${selectedQuiz!.questions.length}',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                '${(score * 100 / selectedQuiz!.questions.length).toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _resetQuiz,
                child: Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedQuiz!.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1} of ${selectedQuiz!.questions.length}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Score: $score',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / selectedQuiz!.questions.length,
              ),
              SizedBox(height: 20),

              // Question
              Text(
                currentQuestion.question,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Options
              ...List.generate(currentQuestion.options.length, (index) {
                final isSelected = selectedAnswer == index;
                final isCorrect = index == currentQuestion.correctAnswer;
                final isWrong = isSelected && !isCorrect;

                Color buttonColor = Colors.grey.shade300;
                if (selectedAnswer != null) {
                  if (isCorrect) {
                    buttonColor = Colors.green.shade200;
                  } else if (isWrong) {
                    buttonColor = Colors.red.shade200;
                  }
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: EdgeInsets.all(16),
                        disabledForegroundColor: Colors.black,
                        disabledBackgroundColor: buttonColor,
                      ),
                      onPressed: selectedAnswer == null ? () => _answerQuestion(index) : null,
                      child: Text(
                        currentQuestion.options[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Explanation
              if (showExplanation) ...[
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explanation:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        currentQuestion.explanation,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text(
                      currentQuestionIndex == selectedQuiz!.questions.length - 1
                          ? 'Finish Quiz'
                          : 'Next Question',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
