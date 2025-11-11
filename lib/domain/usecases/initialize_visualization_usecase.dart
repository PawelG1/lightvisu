import 'package:deckmate/domain/repositories/visualization_repository.dart';

class InitializeVisualizationUsecase {
  final VisualizationRepository repository;

  InitializeVisualizationUsecase({required this.repository});

  Future<void> call() async {
    await repository.loadVesselTypes();
  }
}
