/// Entity reprezentujący konfigurację wizualizacji statku
class VisualizationConfig {
  final double heading;
  final bool showHull;
  final bool showBowArrow;
  final String vesselType;

  const VisualizationConfig({
    required this.heading,
    required this.showHull,
    required this.showBowArrow,
    required this.vesselType,
  });

  VisualizationConfig copyWith({
    double? heading,
    bool? showHull,
    bool? showBowArrow,
    String? vesselType,
  }) {
    return VisualizationConfig(
      heading: heading ?? this.heading,
      showHull: showHull ?? this.showHull,
      showBowArrow: showBowArrow ?? this.showBowArrow,
      vesselType: vesselType ?? this.vesselType,
    );
  }
}
