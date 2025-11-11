part of 'visualization_cubit.dart';

abstract class VisualizationState {}

class VisualizationInitial extends VisualizationState {}

class VisualizationLoading extends VisualizationState {}

class VisualizationLoaded extends VisualizationState {
  final List<String> availableVesselTypes;
  final String selectedVesselType;
  final double heading;
  final bool showHull;
  final bool showBowArrow;

  VisualizationLoaded({
    required this.availableVesselTypes,
    required this.selectedVesselType,
    required this.heading,
    required this.showHull,
    required this.showBowArrow,
  });
}

class VisualizationError extends VisualizationState {
  final String message;

  VisualizationError(this.message);
}
