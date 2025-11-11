# LightVisu - Clean Architecture Structure

## Architektura Projektu

Projekt wykorzystuje **Clean Architecture** z separacją warstw zgodnie z best practices enterprise:

### 📁 Struktura Katalogów

```
lib/
├── main.dart                          # Entry point aplikacji
├── core/
│   └── di/
│       └── service_locator.dart       # Dependency Injection (GetIt)
├── domain/                            # Warstwa biznesowa (niezależna od frameworku)
│   ├── entities/
│   │   └── visualization_config.dart  # Encja konfiguracji wizualizacji
│   ├── repositories/
│   │   ├── visualization_repository.dart
│   │   └── quiz_repository.dart
│   └── usecases/
│       ├── initialize_visualization_usecase.dart
│       └── initialize_quiz_usecase.dart
├── data/                              # Warstwa dostępu do danych
│   └── repositories/
│       ├── visualization_repository_impl.dart
│       └── quiz_repository_impl.dart
├── presentation/                      # Warstwa prezentacji (UI)
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
└── models/                            # Legacy models (do refaktoryzacji)
    ├── vessel_config.dart
    ├── vessel_config_loader.dart
    └── sailing_quiz.dart
```

## 🏗️ Warstwy Architektury

### 1. **Domain Layer** (`lib/domain/`)
- **Odpowiedzialność**: Logika biznesowa niezależna od frameworku
- **Zawiera**:
  - **Entities**: `VisualizationConfig` - główny model domeny
  - **Repositories (Abstract)**: Interfejsy dla dostępu do danych
  - **Usecases**: Operacje biznesowe (`InitializeVisualizationUsecase`, `InitializeQuizUsecase`)

### 2. **Data Layer** (`lib/data/`)
- **Odpowiedzialność**: Implementacja dostępu do danych
- **Zawiera**:
  - **Repositories**: Konkretne implementacje interfejsów z Domain
  - **DataSources**: Połączenia z API, bazą danych, assetami

### 3. **Presentation Layer** (`lib/presentation/`)
- **Odpowiedzialność**: UI i zarządzanie stanem
- **Zawiera**:
  - **Cubits**: `VisualizationCubit`, `QuizCubit` - zarządzanie stanem za pomocą BLoC
  - **States**: Stany aplikacji dla każdego Cubita
  - **Pages**: Główne ekrany (`VisualizationPage`, `QuizPage`)
  - **Widgets**: Komponenty UI (np. `VisualizationContent`)

### 4. **Core Layer** (`lib/core/`)
- **Odpowiedzialność**: Wspólne narzędzia i konfiguracja
- **Zawiera**:
  - **Dependency Injection**: `service_locator.dart` (GetIt)

## 🔄 Flow Danych

```
User Interaction
    ↓
Presentation (BlocBuilder/BlocListener)
    ↓
Cubit (VisualizationCubit/QuizCubit)
    ↓
State (VisualizationLoaded/QuizLoaded)
    ↓
Usecase (InitializeVisualizationUsecase)
    ↓
Repository (VisualizationRepository)
    ↓
DataSource (Assets, API, Database)
```

## 🎯 Zarządzanie Stanem

### VisualizationCubit
```dart
States:
  - VisualizationInitial
  - VisualizationLoading
  - VisualizationLoaded
  - VisualizationError

Methods:
  - initialize()        // Inicjalizacja danych
  - updateHeading()     // Zmiana kierunku
  - updateVesselType()  // Zmiana typu statku
  - toggleHull()        // Włącz/wyłącz kadłub
  - toggleBowArrow()    // Włącz/wyłącz strzałkę rufy
```

### QuizCubit
```dart
States:
  - QuizInitial
  - QuizLoading
  - QuizLoaded
  - QuizError

Methods:
  - initialize()  // Wczytaj pytania z pliku JSON
```

## 💉 Dependency Injection (GetIt)

Wszystkie zależności są rejestrowane w `service_locator.dart`:

```dart
setupServiceLocator() {
  // Rejestracja Repositories
  getIt.registerSingleton<VisualizationRepositoryImpl>(...)
  getIt.registerSingleton<QuizRepositoryImpl>(...)
  
  // Rejestracja Usecases
  getIt.registerSingleton<InitializeVisualizationUsecase>(...)
  getIt.registerSingleton<InitializeQuizUsecase>(...)
  
  // Rejestracja Cubits
  getIt.registerSingleton<VisualizationCubit>(...)
  getIt.registerSingleton<QuizCubit>(...)
}
```

**Zalety**:
- ✅ Łatwa testowalnośc
- ✅ Loose coupling
- ✅ Centralna konfiguracja zależności
- ✅ Możliwość zamiany implementacji bez zmian w kodzie

## 🎨 Główne Cechy Architektury

| Cecha | Opis |
|-------|------|
| **Separation of Concerns** | Każda warstwa ma jasną odpowiedzialność |
| **Testability** | Łatwe mockowanie zależności |
| **Maintainability** | Kod jest logicznie podzielony i łatwy do zmiany |
| **Scalability** | Łatwe dodawanie nowych funkcji bez wpływu na istniejący kod |
| **Independence** | Domain layer nie zależy od frameworku |

## 📦 Pakiety Wykorzystane

- `flutter_bloc: ^9.1.1` - State management
- `get_it: ^7.6.0` - Service locator/Dependency injection

## 🚀 Inicjalizacja Aplikacji

```dart
void main() async {
  // 1. Setup dependency injection
  setupServiceLocator();
  
  // 2. Inicjalizacja danych
  await getIt<VisualizationCubit>().initialize();
  await getIt<QuizCubit>().initialize();
  
  // 3. Uruchomienie aplikacji
  runApp(const MainApp());
}
```

## ✨ Przyszłe Usprawnienia

- [ ] Migracja Legacy Models do Domain Layer
- [ ] Dodanie lokalnego cache'u (SharedPreferences/Hive)
- [ ] Error handling i retry logic
- [ ] Unit i widget tests dla każdego Cubita
- [ ] Logowanie operacji
