import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deckmate/presentation/cubit/visualization/visualization_cubit.dart';
import 'package:deckmate/presentation/widgets/visualization_content.dart';

class VisualizationPage extends StatelessWidget {
  const VisualizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisualizationCubit, VisualizationState>(
      listener: (context, state) {
        if (state is VisualizationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: BlocBuilder<VisualizationCubit, VisualizationState>(
        builder: (context, state) {
          if (state is VisualizationInitial || state is VisualizationLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (state is VisualizationLoaded) {
            return VisualizationContent(state: state);
          }

          if (state is VisualizationError) {
            return Center(
              child: Text('Failed to load visualization: ${state.message}'),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
