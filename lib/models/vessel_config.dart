import 'package:flutter/material.dart';

class VesselConfig {
  final CoordinateSystem coordinateSystem;
  final HullParameters hullParameters;
  final CommonLightDefs commonLightDefs;
  final Map<String, VesselType> vessels;

  VesselConfig({
    required this.coordinateSystem,
    required this.hullParameters,
    required this.commonLightDefs,
    required this.vessels,
  });

  factory VesselConfig.fromJson(Map<String, dynamic> json) {
    return VesselConfig(
      coordinateSystem: CoordinateSystem.fromJson(json['coordinate_system']),
      hullParameters: HullParameters.fromJson(json['hull_parameters']),
      commonLightDefs: CommonLightDefs.fromJson(json['common_light_defs']),
      vessels: (json['vessels'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, VesselType.fromJson(value))),
    );
  }
}

class CoordinateSystem {
  final String originDescription;
  final Map<String, bool> axes;
  final Map<String, dynamic> angles;

  CoordinateSystem({
    required this.originDescription,
    required this.axes,
    required this.angles,
  });

  factory CoordinateSystem.fromJson(Map<String, dynamic> json) {
    return CoordinateSystem(
      originDescription: json['origin'] ?? '',
      axes: Map<String, bool>.from(json['axes'] ?? {}),
      angles: json['angles'] ?? {},
    );
  }
}

class HullParameters {
  final String L; // Overall length
  final String B; // Beam
  final String H; // Reference superstructure height

  HullParameters({required this.L, required this.B, required this.H});

  factory HullParameters.fromJson(Map<String, dynamic> json) {
    return HullParameters(
      L: json['L'] ?? 'overall_length_m',
      B: json['B'] ?? 'beam_m',
      H: json['H'] ?? 'reference_superstructure_height_m',
    );
  }
}

class CommonLightDefs {
  final Map<String, String> colors;
  final Map<String, LightMode> modes;
  final Map<String, dynamic> intensityHints;

  CommonLightDefs({
    required this.colors,
    required this.modes,
    required this.intensityHints,
  });

  factory CommonLightDefs.fromJson(Map<String, dynamic> json) {
    final modesJson = json['modes'] as Map<String, dynamic>? ?? {};
    final modes = modesJson.map(
      (key, value) => MapEntry(key, LightMode.fromJson(value)),
    );

    return CommonLightDefs(
      colors: Map<String, String>.from(json['colors'] ?? {}),
      modes: modes,
      intensityHints: json['intensity_hint_nm'] ?? {},
    );
  }

  Color getColorForLight(String colorName) {
    final hexColor = colors[colorName] ?? '#FFFFFF';
    return _hexToColor(hexColor);
  }

  static Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceFirst('#', '');
    if (hexColor.length == 6) {
      return Color(int.parse('FF$hexColor', radix: 16));
    } else if (hexColor.length == 8) {
      return Color(int.parse(hexColor, radix: 16));
    }
    return Colors.white;
  }
}

class LightMode {
  final String type; // "steady", "flashing", etc.
  final double? flashPeriod;
  final double? dutyCycle;
  final double? flashRatePerMin;

  LightMode({
    required this.type,
    this.flashPeriod,
    this.dutyCycle,
    this.flashRatePerMin,
  });

  factory LightMode.fromJson(Map<String, dynamic> json) {
    return LightMode(
      type: json['type'] ?? 'steady',
      flashPeriod: (json['flash_period_s'] as num?)?.toDouble(),
      dutyCycle: (json['duty_cycle'] as num?)?.toDouble(),
      flashRatePerMin: (json['flash_rate_per_min'] as num?)?.toDouble(),
    );
  }
}

class VesselType {
  final List<String> notes;
  final List<Light> lights;
  final bool? required;

  VesselType({
    required this.notes,
    required this.lights,
    this.required,
  });

  factory VesselType.fromJson(Map<String, dynamic> json) {
    final lightsJson = (json['lights'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final lights = lightsJson.map((l) => Light.fromJson(l)).toList();

    return VesselType(
      notes: List<String>.from(json['notes'] ?? []),
      lights: lights,
      required: json['required'],
    );
  }
}

class Light {
  final String id;
  final String? name;
  final String color; // or list of colors for tricolor
  final String mode;
  final SectorDef sector;
  final PositionExpr position;
  final bool required;
  final String? stackingHint;

  Light({
    required this.id,
    this.name,
    required this.color,
    required this.mode,
    required this.sector,
    required this.position,
    this.required = true,
    this.stackingHint,
  });

  factory Light.fromJson(Map<String, dynamic> json) {
    return Light(
      id: json['id'] ?? '',
      name: json['name'],
      color: json['color'] ?? 'white',
      mode: json['mode'] ?? 'steady',
      sector: SectorDef.fromJson(json['sector_deg'] ?? {}),
      position: PositionExpr.fromJson(json['position_expr'] ?? {}),
      required: json['required'] != false,
      stackingHint: json['stacking_hint'],
    );
  }
}

class SectorDef {
  final double start; // in degrees
  final double end; // in degrees

  SectorDef({required this.start, required this.end});

  factory SectorDef.fromJson(Map<String, dynamic> json) {
    return SectorDef(
      start: (json['start'] as num?)?.toDouble() ?? 0,
      end: (json['end'] as num?)?.toDouble() ?? 360,
    );
  }

  /// Check if an observer angle is within this sector (handles wrap-around at 0/360)
  bool containsAngle(double observerAngle) {
    // Normalize all angles to 0-360
    double obs = observerAngle % 360;
    double s = start % 360;
    double e = end % 360;

    if (obs < 0) obs += 360;
    if (s < 0) s += 360;
    if (e < 0) e += 360;

    // If sector wraps around 0/360
    if (s > e) {
      return obs >= s || obs <= e;
    }
    // Normal sector
    return obs >= s && obs <= e;
  }
}

class PositionExpr {
  final double x;
  final double y;
  final double z;
  final String xOf; // "L", "B", or "H"
  final String yOf;
  final String zOf;

  PositionExpr({
    required this.x,
    required this.y,
    required this.z,
    this.xOf = 'L',
    this.yOf = 'B',
    this.zOf = 'H',
  });

  factory PositionExpr.fromJson(Map<String, dynamic> json) {
    final posOf = json['position_of'] as Map<String, dynamic>? ?? {};

    return PositionExpr(
      x: (json['x'] as num?)?.toDouble() ?? 0,
      y: (json['y'] as num?)?.toDouble() ?? 0,
      z: (json['z'] as num?)?.toDouble() ?? 0,
      xOf: posOf['x_of'] ?? 'L',
      yOf: posOf['y_of'] ?? 'B',
      zOf: posOf['z_of'] ?? 'H',
    );
  }

  /// Calculate actual world coordinates given hull parameters
  /// L, B, H are in meters or any consistent unit
  /// Returns a simple Cartesian coordinates (double triplet)
  ({double x, double y, double z}) toWorldCoords(double L, double B, double H) {
    final actualX = x * L;
    final actualY = y * B;
    final actualZ = z * H;
    return (x: actualX, y: actualY, z: actualZ);
  }
}
