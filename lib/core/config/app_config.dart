/// Centralna konfiguracja aplikacji
class AppConfig {
  static const String appName = 'LightVisu';
  static const String appVersion = '0.1.0';
  
  /// Wizualizacja
  static const double defaultShipHeading = 90.0;
  static const double shipLength = 345.0;  // 115 * 3
  static const double shipBeam = 72.0;     // 24 * 3
  static const double shipHeight = 54.0;   // 18 * 3
  static const bool defaultShowHull = true;
  static const bool defaultShowBowArrow = true;
  
  /// Assets
  static const String vesselConfigAsset = 'assets/vessel_config.json';
  static const String quizAsset = 'assets/sailing_quiz.json';
  
  /// Quiz
  static const int questionsPerQuiz = 10;
  
  /// Timeouts
  static const Duration loadingTimeout = Duration(seconds: 10);
}
