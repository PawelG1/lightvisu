# 🚢 LightVisu - Maritime Navigation Light Visualization

> Advanced Flutter application with **Clean Architecture** demonstrating COLREG-compliant maritime navigation lights visualization and interactive sailing quiz.

---

## 📋 Spis Treści

- [🎯 Przegląd](#-przegląd)
- [🏗️ Architektura](#-architektura)
- [🚀 Uruchomienie](#-uruchomienie)
- [📁 Struktura Projektu](#-struktura-projektu)
- [🔧 Konfiguracja](#-konfiguracja)
- [📚 Dokumentacja Techniczna](#-dokumentacja-techniczna)
- [🧪 Testowanie](#-testowanie)
- [📦 Zależności](#-zależności)

---

## 🎯 Przegląd

**LightVisu** to zaawansowana aplikacja Flutter demonstrująca:

### ✨ Główne Funkcje
- **3D Wizualizacja Statków** - Perspektywiczna projekcja XZ z wykorzystaniem CustomPaint
- **Światła Nawigacyjne COLREG** - Główne, boczne, rufowe światła z sektorem widoczności
- **Interaktywne Quiz** - 10 pytań COLREG z wyjaśnieniami
- **Dynamiczna Konfiguracja** - Wczytywanie typów statków z JSON
- **Responsive UI** - Obsługa wielu platform (Android, iOS, Linux, Web)

### 🏛️ Architektura
- **Clean Architecture** z pełną separacją warstw
- **BLoC Pattern** dla zarządzania stanem
- **Dependency Injection** (GetIt Service Locator)
- **Enterprise-Grade Code Quality**

---

## 🏗️ Architektura

### Warstwy Systemu

```
┌─────────────────────────────────────────────┐
│        Presentation Layer                   │
│  Pages, Widgets, Cubits, States             │
└────────────┬────────────────────────────────┘
             │
┌────────────▼────────────────────────────────┐
│        Domain Layer                         │
│  Entities, Repositories, Usecases           │
└────────────┬────────────────────────────────┘
             │
┌────────────▼────────────────────────────────┐
│        Data Layer                           │
│  Repository Implementations                 │
└────────────┬────────────────────────────────┘
             │
┌────────────▼────────────────────────────────┐
│        External Sources                     │
│  JSON Assets, Databases, APIs               │
└─────────────────────────────────────────────┘
```

### Zarządzanie Stanem

```dart
// VisualizationCubit States
- VisualizationInitial     // Stan początkowy
- VisualizationLoading     // Ładowanie danych
- VisualizationLoaded      // Dane dostępne
- VisualizationError       // Błąd

// QuizCubit States
- QuizInitial              // Stan początkowy
- QuizLoading              // Ładowanie pytań
- QuizLoaded               // Quiz gotowy
- QuizError                // Błąd
```

---

## 🚀 Uruchomienie

### Wymagania
- Flutter >= 3.9.2
- Dart >= 3.0
- iOS 11+ / Android 5+ / Linux / Web

### Instalacja

```bash
# Klonowanie repozytorium
git clone https://github.com/mecharolnik/lightvisu.git
cd lightvisu

# Pobieranie zależności
flutter pub get

# Uruchomienie na domyślnym urządzeniu
flutter run

# Uruchomienie na konkretnym urządzeniu
flutter run -d linux
flutter run -d chrome
```

### Build

```bash
# Release build
flutter build linux
flutter build apk
flutter build ios

# Web
flutter build web --release
```

---

## 📁 Struktura Projektu

```
lib/
├── main.dart                              # Entry point
├── core/
│   ├── di/
│   │   └── service_locator.dart           # GetIt setup
│   ├── config/
│   │   └── app_config.dart                # Centralna konfiguracja
│   └── constants/
│       └── app_constants.dart             # Stałe i stringi
│
├── domain/                                # Warstwa biznesowa
│   ├── entities/
│   │   └── visualization_config.dart
│   ├── repositories/
│   │   ├── visualization_repository.dart
│   │   └── quiz_repository.dart
│   └── usecases/
│       ├── initialize_visualization_usecase.dart
│       └── initialize_quiz_usecase.dart
│
├── data/                                  # Warstwa danych
│   └── repositories/
│       ├── visualization_repository_impl.dart
│       └── quiz_repository_impl.dart
│
├── presentation/                          # Warstwa prezentacji
│   ├── cubit/
│   │   ├── visualization/
│   │   │   ├── visualization_cubit.dart
│   │   │   └── visualization_state.dart
│   │   └── quiz/
│   │       ├── quiz_cubit.dart
│   │       └── quiz_state.dart
│   ├── pages/
│   │   ├── visualization_page.dart
│   │   └── quiz_page.dart
│   └── widgets/
│       └── visualization_content.dart
│
└── models/                                # Legacy models
    ├── vessel_config.dart
    ├── vessel_config_loader.dart
    └── sailing_quiz.dart

assets/
├── vessel_config.json                     # Konfiguracje statków
└── sailing_quiz.json                      # Pytania quizu
```

---

## 🔧 Konfiguracja

### AppConfig

Centralna konfiguracja w `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  static const double defaultShipHeading = 90.0;
  static const double shipLength = 345.0;
  static const double shipBeam = 72.0;
  static const double shipHeight = 54.0;
  static const String vesselConfigAsset = 'assets/vessel_config.json';
  static const String quizAsset = 'assets/sailing_quiz.json';
}
```

### Service Locator Setup

```dart
// main.dart
void main() async {
  setupServiceLocator();
  await getIt<VisualizationCubit>().initialize();
  await getIt<QuizCubit>().initialize();
  runApp(const MainApp());
}
```

---

## 📚 Dokumentacja Techniczna

### VisualizationCubit

```dart
class VisualizationCubit extends Cubit<VisualizationState> {
  // Metody publiczne
  Future<void> initialize()           // Inicjalizacja
  void updateHeading(double heading)  // Zmiana kierunku
  void updateVesselType(String type)  // Zmiana typu
  void toggleHull()                   // Włącz/wyłącz kadłub
  void toggleBowArrow()               // Włącz/wyłącz strzałkę
}
```

### QuizCubit

```dart
class QuizCubit extends Cubit<QuizState> {
  // Metody publiczne
  Future<void> initialize()  // Wczytaj pytania
}
```

### Dependency Injection

```dart
// Pobieranie instancji
final cubit = getIt<VisualizationCubit>();
final repository = getIt<VisualizationRepositoryImpl>();

// Użycie w widgetach
BlocProvider<VisualizationCubit>.value(
  value: getIt<VisualizationCubit>(),
)
```

---

## 🧪 Testowanie

### Unit Tests (Przyszłość)

```dart
testWidgets('VisualizationCubit initializes correctly', (tester) async {
  final cubit = VisualizationCubit(
    initializeUsecase: mockUsecase,
    repository: mockRepository,
  );
  
  await cubit.initialize();
  
  expect(cubit.state, isA<VisualizationLoaded>());
});
```

### Analiza Kodu

```bash
flutter analyze
flutter format lib/
dart fix --apply
```

---

## 📦 Zależności

| Pakiet | Wersja | Przeznaczenie |
|--------|--------|---------------|
| `flutter_bloc` | ^9.1.1 | State management |
| `get_it` | ^7.6.0 | Service locator/DI |
| `vector_math` | ^2.1.0 | Transformacje macierzowe |

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.1.1
  get_it: ^7.6.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

## 🎨 Wizualizacja 3D

### Projekcja Perspektywiczna

```dart
Point3D.toPerspective({
  required double perspective = 500,
  required double scale = 1,
}) {
  final distanceScale = perspective / (perspective + y);
  return Point(x * scale * distanceScale, -z * scale);
}
```

### Transformacja Macierzowa

```dart
final matrix = Matrix4.identity();
matrix.rotateZ(degrees2Rad(angle));  // Rotacja wokół osi Z
final transformedPoint = matrix.transform3(point);
```

---

## 📊 Flow Danych

```
UI Event
  ↓
Cubit Method (e.g., updateHeading)
  ↓
Emit New State (VisualizationLoaded)
  ↓
BlocBuilder Widget Rebuild
  ↓
UI Render with New Data
```

---

## 🔒 Best Practices

✅ **Separation of Concerns** - Każda warstwa ma jasną odpowiedzialność
✅ **Dependency Injection** - Loose coupling
✅ **Single Responsibility** - Każda klasa jeden powód do zmian
✅ **Interface Segregation** - Abstrakcje dla repositories
✅ **Open/Closed Principle** - Otwarte na rozszerzenie, zamknięte na modyfikację

---

## 🛣️ Roadmap

- [ ] Unit testy dla Cubitów
- [ ] Widget testy dla Pages
- [ ] Integracja z lokalnym cache'm (SharedPreferences)
- [ ] Animacje przejść między stronami
- [ ] Dark mode
- [ ] Wielojęzyczność (i18n)
- [ ] Real-time weather integration
- [ ] Zaawansowana statystyka quizu

---

## 📝 Licencja

MIT License - zobacz LICENSE dla szczegółów

---

## 👨‍💻 Autor

Projekt demonstracyjny architektury enterprise w Flutter

---

## 🤝 Contribution

Zapraszamy do składania pull requestów i reportowania bugów!

