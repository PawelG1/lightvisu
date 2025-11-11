import 'package:deckmate/domain/repositories/visualization_repository.dart';
import 'package:deckmate/models/vessel_config.dart' as vc;
import 'package:deckmate/models/vessel_config_loader.dart';

class VisualizationRepositoryImpl implements VisualizationRepository {
  late vc.VesselConfig _vesselConfig;
  late List<String> _availableVesselTypes;

  @override
  Future<void> loadVesselTypes() async {
    try {
      _vesselConfig = await VesselConfigLoader.loadFromAssets('assets/vessel_config.json');
      _availableVesselTypes = await VesselConfigLoader.getAvailableVesselTypes('assets/vessel_config.json');
    } catch (e) {
      throw Exception('Failed to load vessel types: $e');
    }
  }

  @override
  List<String> getAvailableVesselTypes() {
    return List.unmodifiable(_availableVesselTypes);
  }

  @override
  String? getDefaultVesselType() {
    return _availableVesselTypes.isNotEmpty ? _availableVesselTypes.first : null;
  }

  vc.VesselType? getVesselType(String type) {
    return _vesselConfig.vessels[type];
  }
}
