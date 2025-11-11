import 'package:flutter/material.dart';
import 'package:deckmate/models/sailing_quiz.dart';
import 'package:deckmate/quiz_topic_selector.dart';

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
  bool showingTopicSelector = true; // Show selector by default

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
      // Error loading quiz - handled by error state in presentation layer
      rethrow;
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

  void _selectQuiz(Quiz quiz) {
    setState(() {
      selectedQuiz = quiz;
      showingTopicSelector = false;
      _resetQuiz();
    });
  }

  void _backToTopicSelector() {
    setState(() {
      showingTopicSelector = true;
      _resetQuiz();
    });
  }

  QuizQuestion get currentQuestion => selectedQuiz!.questions[currentQuestionIndex];

  @override
  Widget build(BuildContext context) {
    // Show topic selector if loading or user wants to change topic
    if (quizData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sailing Quiz')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (showingTopicSelector) {
      return QuizTopicSelector(
        quizData: quizData!,
        onQuizSelected: _selectQuiz,
      );
    }

    if (selectedQuiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sailing Quiz')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (quizComplete) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Complete'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _backToTopicSelector,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Quiz Complete!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Your Score: $score / ${selectedQuiz!.questions.length}',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Text(
                '${(score * 100 / selectedQuiz!.questions.length).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _resetQuiz,
                child: const Text('Try Again'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _backToTopicSelector,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Choose Different Topic'),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _backToTopicSelector,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1} of ${selectedQuiz!.questions.length}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Score: $score',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / selectedQuiz!.questions.length,
              ),
              const SizedBox(height: 20),

              // Question
              Text(
                currentQuestion.question,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

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
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.all(16),
                        disabledForegroundColor: Colors.black,
                        disabledBackgroundColor: buttonColor,
                      ),
                      onPressed: selectedAnswer == null ? () => _answerQuestion(index) : null,
                      child: Text(
                        currentQuestion.options[index],
                        style: const TextStyle(
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
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explanation:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentQuestion.explanation,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
