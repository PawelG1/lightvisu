import 'dart:convert';
import 'package:flutter/services.dart';
import 'vessel_config.dart';

class VesselConfigLoader {
  static Future<VesselConfig> loadFromAssets(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return VesselConfig.fromJson(jsonMap);
    } catch (e) {
      print('Error loading vessel config: $e');
      rethrow;
    }
  }

  /// Get a specific vessel type by key
  static Future<VesselType?> getVesselType(
    String assetPath,
    String vesselTypeKey,
  ) async {
    try {
      final config = await loadFromAssets(assetPath);
      return config.vessels[vesselTypeKey];
    } catch (e) {
      print('Error getting vessel type: $e');
      return null;
    }
  }

  /// Get all available vessel type keys
  static Future<List<String>> getAvailableVesselTypes(String assetPath) async {
    try {
      final config = await loadFromAssets(assetPath);
      return config.vessels.keys.toList();
    } catch (e) {
      print('Error getting vessel types: $e');
      return [];
    }
  }
}
