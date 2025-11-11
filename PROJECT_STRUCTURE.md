# 📊 Struktura Projektu LightVisu

## Drzewo Katalogów

```
lightvisu/
├── lib/
│   ├── main.dart                                    # ⭐ Entry point
│   ├── core/
│   │   └── di/
│   │       └── service_locator.dart                 # 💉 GetIt DI setup
│   │
│   ├── domain/                                      # 🏗️ Warstwa biznesowa
│   │   ├── entities/
│   │   │   └── visualization_config.dart
│   │   ├── repositories/
│   │   │   ├── visualization_repository.dart
│   │   │   └── quiz_repository.dart
│   │   └── usecases/
│   │       ├── initialize_visualization_usecase.dart
│   │       └── initialize_quiz_usecase.dart
│   │
│   ├── data/                                        # 🗄️ Warstwa danych
│   │   └── repositories/
│   │       ├── visualization_repository_impl.dart
│   │       └── quiz_repository_impl.dart
│   │
│   ├── presentation/                                # 🎨 Warstwa prezentacji
│   │   ├── cubit/
│   │   │   ├── visualization/
│   │   │   │   ├── visualization_cubit.dart
│   │   │   │   └── visualization_state.dart
│   │   │   └── quiz/
│   │   │       ├── quiz_cubit.dart
│   │   │       └── quiz_state.dart
│   │   ├── pages/
│   │   │   ├── visualization_page.dart
│   │   │   └── quiz_page.dart
│   │   └── widgets/
│   │       └── visualization_content.dart
│   │
│   ├── models/                                      # 🔄 Legacy (do refaktoryzacji)
│   │   ├── vessel_config.dart
│   │   ├── vessel_config_loader.dart
│   │   └── sailing_quiz.dart
│   │
│   ├── bloc/                                        # 🔄 Legacy
│   │   └── slider_cubit.dart
│   │
│   └── lights2_widget.dart                         # 🎨 3D Rendering
│
├── assets/
│   ├── vessel_config.json                          # ⚙️ Konfiguracje statków
│   └── sailing_quiz.json                           # ❓ Pytania quizu
│
├── android/                                         # 🤖 Android
├── ios/                                            # 🍎 iOS
├── linux/                                          # 🐧 Linux
├── web/                                            # 🌐 Web
├── windows/                                        # 🪟 Windows
├── macos/                                          # 🍎 macOS
│
├── pubspec.yaml                                    # 📦 Zależności
├── pubspec.lock
├── analysis_options.yaml                           # 🔍 Linting
├── devtools_options.yaml
├── ARCHITECTURE.md                                 # 📖 Clean Architecture
└── README.md
```

## 🔗 Zależności Między Modułami

```
main.dart (Entry Point)
    ↓
service_locator.dart (DI Setup)
    ↓ ┌─────────────────────────────────────┐
    ↓ ↓                                     ↓
VisualizationCubit                      QuizCubit
    ↓                                       ↓
InitializeVisualizationUsecase      InitializeQuizUsecase
    ↓                                       ↓
VisualizationRepository              QuizRepository
    ↓                                       ↓
VesselConfigLoader                   SailingQuizLoader
    ↓                                       ↓
assets/vessel_config.json          assets/sailing_quiz.json
```

## 📐 Diagnozy Odpowiedzialności Warstw

```
┌────────────────────────────────────────────┐
│        Presentation Layer                   │
│  (Pages, Widgets, Cubits, States)          │
│  - VisualizationPage                        │
│  - QuizPage                                 │
│  - VisualizationCubit                       │
│  - QuizCubit                                │
└────────────┬─────────────────────────────────┘
             │
             ↓
┌────────────────────────────────────────────┐
│        Domain Layer                         │
│  (Entities, Repositories, Usecases)        │
│  - VisualizationConfig (Entity)             │
│  - VisualizationRepository (Interface)      │
│  - InitializeVisualizationUsecase           │
│  - InitializeQuizUsecase                    │
└────────────┬─────────────────────────────────┘
             │
             ↓
┌────────────────────────────────────────────┐
│        Data Layer                           │
│  (Repository Implementations)               │
│  - VisualizationRepositoryImpl               │
│  - QuizRepositoryImpl                        │
└────────────┬─────────────────────────────────┘
             │
             ↓
┌────────────────────────────────────────────┐
│        External Sources                     │
│  (Assets, Databases, APIs)                  │
│  - vessel_config.json                       │
│  - sailing_quiz.json                        │
│  - Local cache (w przyszłości)              │
└────────────────────────────────────────────┘
```

## 🔄 Stan Maszyny - VisualizationCubit

```
┌─────────────────────┐
│ VisualizationInitial│
│   (Stan początkowy) │
└──────────┬──────────┘
           │ initialize()
           ↓
┌─────────────────────┐
│ VisualizationLoading│
│  (Ładowanie danych) │
└──────────┬──────────┘
           │ ✓ Sukces / ✗ Błąd
           ├─────────────────────────────────┐
           │                                 │
           ↓                                 ↓
┌─────────────────────┐       ┌──────────────────────┐
│VisualizationLoaded  │       │VisualizationError    │
│ (Dane dostępne)     │       │ (Błąd przy ładowaniu)│
└──────────┬──────────┘       └──────────────────────┘
           │
    ┌──────┴──────┬──────────────┬─────────────┐
    ↓             ↓              ↓             ↓
updateHeading updateVessel   toggleHull  toggleBowArrow
    │             │              │             │
    └──────┬──────┴──────────────┴─────────────┘
           ↓
    VisualizationLoaded
    (Nowy stan)
```

## 🎯 Użycie GetIt (Service Locator)

```dart
// Rejestracja (setup_service_locator.dart)
getIt.registerSingleton<VisualizationCubit>(...)

// Użycie w aplikacji
final cubit = getIt<VisualizationCubit>();
await cubit.initialize();

// W widgetach
BlocProvider<VisualizationCubit>.value(
  value: getIt<VisualizationCubit>(),
)
```

**Zalety GetIt:**
- ✅ Globalna referencja do singletonów
- ✅ Łatwe mockowanie w testach
- ✅ Centralne zarządzanie cyklem życia
- ✅ Brak konieczności przekazywania przez context

## 📤 Flow Danych w Wizualizacji

```
UI Event (Slider zmiana)
    ↓
cubit.updateHeading(270.0)
    ↓
Emit VisualizationLoaded(heading: 270.0, ...)
    ↓
BlocBuilder rebuild
    ↓
VisualizationContent wyświetla nowy stan
    ↓
Lights2Widget renderuje statek z nowym kątem
```

## 📊 Wiadomości Między Warstwami

| Z         | Do        | Typ              | Przykład |
|-----------|-----------|------------------|----------|
| UI        | Cubit     | User Action      | `updateHeading(270.0)` |
| Cubit     | Repository| Request          | `loadVesselTypes()` |
| Repository| DataSource| Read             | `VesselConfigLoader.load()` |
| DataSource| Repository| Response         | `VesselConfig` |
| Repository| Cubit     | Result           | Lista typów statków |
| Cubit     | UI        | State            | `VisualizationLoaded` |

## 🧪 Testabilność Architektury

```dart
// Mockowanie Repository
class MockVisualizationRepository implements VisualizationRepository {
  @override
  Future<void> loadVesselTypes() async { /* stub */ }
  
  @override
  List<String> getAvailableVesselTypes() => ['mock_type'];
}

// Test Cubita
testWidgets('updateHeading should emit new state', (tester) async {
  final cubit = VisualizationCubit(
    initializeUsecase: mockUsecase,
    repository: MockVisualizationRepository(),
  );
  
  cubit.updateHeading(180.0);
  
  expect(
    cubit.stream,
    emits(isA<VisualizationLoaded>()),
  );
});
```
