# 📖 Development Guidelines - LightVisu

## 🏗️ Standardy Kodowania

### Konwencje Nazewnictwa

```dart
// ✅ Cubits - PascalCase + "Cubit"
class VisualizationCubit extends Cubit { }
class QuizCubit extends Cubit { }

// ✅ States - PascalCase + State + Name
abstract class VisualizationState { }
class VisualizationLoading extends VisualizationState { }
class VisualizationLoaded extends VisualizationState { }

// ✅ Pages - PascalCase + "Page"
class VisualizationPage extends StatelessWidget { }

// ✅ Repositories - abstract + Impl
abstract class VisualizationRepository { }
class VisualizationRepositoryImpl implements VisualizationRepository { }

// ✅ Usecases - PascalCase + "Usecase"
class InitializeVisualizationUsecase { }

// ✅ Prywatne metody - camelCase z underscore
void _buildShipVisualization() { }
```

### Struktura Klasy

```dart
// Przykład prawidłowej struktury Cubita
class VisualizationCubit extends Cubit<VisualizationState> {
  // 1. Zdeklaruj zależności
  final InitializeVisualizationUsecase initializeUsecase;
  final VisualizationRepositoryImpl repository;

  // 2. Konstruktor
  VisualizationCubit({
    required this.initializeUsecase,
    required this.repository,
  }) : super(VisualizationInitial());

  // 3. Publiczne metody (w kolejności logicznej)
  Future<void> initialize() async { }
  void updateHeading(double heading) { }
  void updateVesselType(String vesselType) { }

  // 4. Prywatne metody
  void _emitState() { }
}
```

---

## 📂 Dodawanie Nowej Funkcji

### Krok 1: Domain Layer

```dart
// lib/domain/usecases/my_usecase.dart
class MyUsecase {
  final MyRepository repository;
  
  MyUsecase({required this.repository});
  
  Future<void> call() async {
    // Logika biznesowa
  }
}

// lib/domain/repositories/my_repository.dart
abstract class MyRepository {
  Future<void> myMethod();
}
```

### Krok 2: Data Layer

```dart
// lib/data/repositories/my_repository_impl.dart
class MyRepositoryImpl implements MyRepository {
  @override
  Future<void> myMethod() async {
    // Implementacja - dostęp do danych
  }
}
```

### Krok 3: Presentation Layer

```dart
// lib/presentation/cubit/my_feature/my_feature_state.dart
abstract class MyFeatureState {}
class MyFeatureLoading extends MyFeatureState {}
class MyFeatureLoaded extends MyFeatureState { }

// lib/presentation/cubit/my_feature/my_feature_cubit.dart
class MyFeatureCubit extends Cubit<MyFeatureState> {
  final MyUsecase usecase;
  
  MyFeatureCubit({required this.usecase}) 
    : super(MyFeatureState());
}

// lib/presentation/pages/my_feature_page.dart
class MyFeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFeatureCubit, MyFeatureState>(
      builder: (context, state) {
        // Render UI
      },
    );
  }
}
```

### Krok 4: Dependency Injection

```dart
// lib/core/di/service_locator.dart
void setupServiceLocator() {
  // Dodaj nowe rejestracje
  getIt.registerSingleton<MyRepository>(
    MyRepositoryImpl(),
  );
  
  getIt.registerSingleton<MyUsecase>(
    MyUsecase(repository: getIt<MyRepository>()),
  );
  
  getIt.registerSingleton<MyFeatureCubit>(
    MyFeatureCubit(usecase: getIt<MyUsecase>()),
  );
}
```

---

## 🧹 Code Quality

### Analiza Kodu

```bash
# Uruchomienie analizy statycznej
flutter analyze

# Format kodu
dart format lib/

# Automatic fixes
dart fix --apply
```

### Linting Rules

Projekt używa `flutter_lints: ^5.0.0`. Konfiguracja w `analysis_options.yaml`.

### ESLint Reguły do Unikania

```dart
// ❌ Unikaj print w production
print('Debug message');

// ✅ Używaj dedykowanego loggera
logger.debug('Debug message');

// ❌ Unikaj spread operators na listach
List items = [...someList.toList()];

// ✅ Użyj bezpośrednio
List items = [...someList];

// ❌ Unikaj Deprecated APIs
color.withOpacity(0.5);

// ✅ Używaj nowych API
color.withValues(alpha: 0.5);
```

---

## 🧪 Testing

### Unit Test Template

```dart
// test/presentation/cubit/visualization_cubit_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lightvisu/presentation/cubit/visualization/visualization_cubit.dart';

void main() {
  group('VisualizationCubit', () {
    late VisualizationCubit cubit;
    late MockInitializeVisualizationUsecase mockUsecase;
    late MockVisualizationRepository mockRepository;

    setUp(() {
      mockUsecase = MockInitializeVisualizationUsecase();
      mockRepository = MockVisualizationRepository();
      cubit = VisualizationCubit(
        initializeUsecase: mockUsecase,
        repository: mockRepository,
      );
    });

    test('initial state is VisualizationInitial', () {
      expect(cubit.state, isA<VisualizationInitial>());
    });

    test('updateHeading emits new state', () async {
      cubit.updateHeading(180.0);
      
      expect(
        cubit.stream,
        emits(isA<VisualizationLoaded>()),
      );
    });
  });
}
```

### Widget Test Template

```dart
// test/presentation/pages/visualization_page_test.dart
void main() {
  testWidgets('VisualizationPage renders correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<VisualizationCubit>.value(
          value: mockCubit,
          child: VisualizationPage(),
        ),
      ),
    );

    expect(find.byType(VisualizationPage), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
  });
}
```

---

## 📝 Commit Message Guidelines

Używaj konwencji Conventional Commits:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Przykłady

```
✅ GOOD:
feat(visualization): add heading update functionality
  - Implemented updateHeading method
  - Added state emission logic
  - Closes #123

fix(quiz): fix quiz loading timeout
  - Increased timeout from 5s to 10s
  - Added retry logic

✅ GOOD:
refactor(cubit): reorganize VisualizationCubit methods
  - Moved private methods to bottom
  - Extracted state emission logic

docs(architecture): update Clean Architecture docs
  - Added new diagram
  - Clarified dependencies between layers

❌ AVOID:
- "fixed stuff" 
- "update code"
- "WIP"
- "test"
```

---

## 🔄 Pull Request Checklist

Przed submission PR, sprawdź:

- [ ] Kod przechodzi `flutter analyze`
- [ ] Kod jest sformatowany (`dart format lib/`)
- [ ] Dodane/zmienione pliki mają dokumentację
- [ ] Testy przechodzą (jeśli istnieją)
- [ ] Nie ma debug print'ów
- [ ] Commit messaje są jasne
- [ ] PR description wyjaśnia zmiany
- [ ] Następne kroki są zdokumentowane (jeśli potrzebne)

---

## 📚 Dokumentacja Kodu

### Doc Comments

```dart
/// Wizualizuje statek z wybranym kątem.
///
/// Przyjmuje kąt w stopniach (0-360) i emituje nowy stan
/// zawierający zaktualizowaną konfigurację.
///
/// Parametry:
///   - [heading] Kąt kierunku (0-360 stopni)
///
/// Wyrzuca:
///   - Nic (emituje stan zamiast)
///
/// Przykład:
/// ```dart
/// cubit.updateHeading(270.0);
/// ```
void updateHeading(double heading) {
  // Implementacja
}
```

### Dokumentacja Klasy

```dart
/// Zarządza stanem wizualizacji statku.
///
/// Odpowiadał za:
/// - Załadowanie dostępnych typów statków
/// - Zarządzanie aktualnym kierunkiem
/// - Przełączanie opcji wyświetlania
///
/// Zmiany stanu:
/// - [VisualizationInitial] → Initial state
/// - [VisualizationLoading] → While loading data
/// - [VisualizationLoaded] → When data is ready
/// - [VisualizationError] → On error
class VisualizationCubit extends Cubit<VisualizationState> {
  // ...
}
```

---

## 🐛 Debugowanie

### Print Debuggingu (DEV ONLY)

```dart
// ✅ Dodaj do development
if (kDebugMode) {
  print('Debug: $value');
}

// ❌ Unikaj w production
print('Debug: $value');
```

### Flutter DevTools

```bash
# Uruchom devtools
flutter pub global activate devtools
devtools

# Z poziomu aplikacji
flutter run --observatory-port 8888
```

---

## 📊 Performance Optimization

### BlocBuilder Optimization

```dart
// ✅ Limituj rebuilds z `buildWhen`
BlocBuilder<VisualizationCubit, VisualizationState>(
  buildWhen: (previous, current) {
    // Rebuild tylko jeśli zmienił się heading
    return (previous is VisualizationLoaded && 
            current is VisualizationLoaded && 
            previous.heading != current.heading);
  },
  builder: (context, state) {
    // Build UI
  },
)
```

### Widget Memoization

```dart
// ✅ Wydziel widgety by uniknąć niepotrzebnych rebuilds
class _ShipVisualization extends StatelessWidget {
  final vc.VesselType vessel;
  final double heading;
  
  const _ShipVisualization({
    required this.vessel,
    required this.heading,
  });
  
  @override
  Widget build(BuildContext context) => Lights2Widget(...);
}
```

---

## 🔒 Security Best Practices

```dart
// ✅ Waliduj input
void updateHeading(double heading) {
  if (heading < 0 || heading > 360) {
    throw ArgumentError('Heading must be between 0 and 360');
  }
  // Continue
}

// ✅ Obsługuj błędy
try {
  await repository.loadData();
} catch (e) {
  emit(VisualizationError(e.toString()));
}

// ❌ Unikaj expose sensitive data
// ❌ Nie loguj passwords czy tokens
// ❌ Nie hardcoduj API keys
```

---

## 📞 Kontakt & Support

Pytania dotyczące development guidelines:
- Otwórz Issue na GitHub
- Dyskusja w PR review

