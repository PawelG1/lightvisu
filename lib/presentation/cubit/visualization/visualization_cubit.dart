import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deckmate/domain/usecases/initialize_visualization_usecase.dart';
import 'package:deckmate/data/repositories/visualization_repository_impl.dart';

part 'visualization_state.dart';

class VisualizationCubit extends Cubit<VisualizationState> {
  final InitializeVisualizationUsecase initializeUsecase;
  final VisualizationRepositoryImpl repository;

  VisualizationCubit({
    required this.initializeUsecase,
    required this.repository,
  }) : super(VisualizationInitial());

  Future<void> initialize() async {
    try {
      emit(VisualizationLoading());
      await initializeUsecase();
      
      final vesselTypes = repository.getAvailableVesselTypes();
      final defaultVessel = repository.getDefaultVesselType() ?? vesselTypes.first;
      
      emit(VisualizationLoaded(
        availableVesselTypes: vesselTypes,
        selectedVesselType: defaultVessel,
        heading: 90.0,
        showHull: true,
        showBowArrow: true,
      ));
    } catch (e) {
      emit(VisualizationError(e.toString()));
    }
  }

  void updateHeading(double heading) {
    final state = this.state;
    if (state is VisualizationLoaded) {
      emit(VisualizationLoaded(
        availableVesselTypes: state.availableVesselTypes,
        selectedVesselType: state.selectedVesselType,
        heading: heading,
        showHull: state.showHull,
        showBowArrow: state.showBowArrow,
      ));
    }
  }

  void updateVesselType(String vesselType) {
    final state = this.state;
    if (state is VisualizationLoaded) {
      emit(VisualizationLoaded(
        availableVesselTypes: state.availableVesselTypes,
        selectedVesselType: vesselType,
        heading: state.heading,
        showHull: state.showHull,
        showBowArrow: state.showBowArrow,
      ));
    }
  }

  void toggleHull() {
    final state = this.state;
    if (state is VisualizationLoaded) {
      emit(VisualizationLoaded(
        availableVesselTypes: state.availableVesselTypes,
        selectedVesselType: state.selectedVesselType,
        heading: state.heading,
        showHull: !state.showHull,
        showBowArrow: state.showBowArrow,
      ));
    }
  }

  void toggleBowArrow() {
    final state = this.state;
    if (state is VisualizationLoaded) {
      emit(VisualizationLoaded(
        availableVesselTypes: state.availableVesselTypes,
        selectedVesselType: state.selectedVesselType,
        heading: state.heading,
        showHull: state.showHull,
        showBowArrow: !state.showBowArrow,
      ));
    }
  }
}
