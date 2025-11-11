abstract class VisualizationRepository {
  Future<void> loadVesselTypes();
  List<String> getAvailableVesselTypes();
  String? getDefaultVesselType();
}
