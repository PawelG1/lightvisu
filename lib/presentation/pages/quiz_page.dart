import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deckmate/presentation/cubit/quiz/quiz_cubit.dart';
import 'package:deckmate/quiz_screen.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizCubit, QuizState>(
      listener: (context, state) {
        if (state is QuizError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Quiz Error: ${state.message}')),
          );
        }
      },
      child: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state is QuizInitial || state is QuizLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (state is QuizLoaded) {
            return QuizScreen();
          }

          if (state is QuizError) {
            return Center(
              child: Text('Failed to load quiz: ${state.message}'),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
