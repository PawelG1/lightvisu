/// Nazwy tras nawigacji (do przyszłej implementacji)
class Routes {
  static const String visualization = '/visualization';
  static const String quiz = '/quiz';
}

/// Klucze dla lokalnego storage (SharedPreferences/Hive)
class StorageKeys {
  static const String lastSelectedVesselType = 'last_selected_vessel_type';
  static const String lastHeading = 'last_heading';
  static const String quizScore = 'quiz_score';
  static const String quizHistory = 'quiz_history';
}

/// Wiadomości błędów
class ErrorMessages {
  static const String loadingFailed = 'Failed to load data';
  static const String networkError = 'Network error occurred';
  static const String configurationError = 'Configuration loading failed';
}

/// Tekst UI
class UIStrings {
  static const String appTitle = 'LightVisu';
  static const String visualization = 'Visualization';
  static const String quiz = 'Quiz';
  static const String frontView = 'Front View';
  static const String portSide = 'Port Side';
  static const String starboardSide = 'Starboard Side';
  static const String sternView = 'Stern View';
  static const String showHull = 'Show Hull';
  static const String showBowArrow = 'Show BOW Arrow';
  static const String vesselInformation = 'Vessel Information:';
  static const String heading = 'Heading:';
}
