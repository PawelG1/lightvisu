# 📚 LightVisu Architecture - Usage Examples

## EXAMPLE 1: Jak dodać nową feature - "Zapisz ustawienia"

### Step 1: Domain Layer

```dart
// lib/domain/repositories/settings_repository.dart
abstract class SettingsRepository {
  Future<void> saveVisualizationSettings(VisualizationConfig config);
  Future<VisualizationConfig> loadVisualizationSettings();
}

// lib/domain/usecases/save_settings_usecase.dart
class SaveSettingsUsecase {
  final SettingsRepository repository;
  
  SaveSettingsUsecase({required this.repository});
  
  Future<void> call(VisualizationConfig config) async {
    await repository.saveVisualizationSettings(config);
  }
}
```

---

## EXAMPLE 2: Data Layer

```dart
// lib/data/repositories/settings_repository_impl.dart
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences prefs;
  
  SettingsRepositoryImpl({required this.prefs});
  
  @override
  Future<void> saveVisualizationSettings(VisualizationConfig config) async {
    await prefs.setDouble('heading', config.heading);
    await prefs.setBool('showHull', config.showHull);
    await prefs.setString('vesselType', config.vesselType);
  }
  
  @override
  Future<VisualizationConfig> loadVisualizationSettings() async {
    return VisualizationConfig(
      heading: prefs.getDouble('heading') ?? 90.0,
      showHull: prefs.getBool('showHull') ?? true,
      showBowArrow: prefs.getBool('showBowArrow') ?? true,
      vesselType: prefs.getString('vesselType') ?? 'power_driven_underway_upto_50m',
    );
  }
}
```

---

## EXAMPLE 3: Rozszerzenie Cubita o nową funkcjonalność

```dart
// lib/presentation/cubit/visualization/visualization_cubit.dart
class VisualizationCubit extends Cubit<VisualizationState> {
  final InitializeVisualizationUsecase initializeUsecase;
  final VisualizationRepositoryImpl repository;
  final SaveSettingsUsecase saveSettingsUsecase;  // ← Nowa zależność
  
  VisualizationCubit({
    required this.initializeUsecase,
    required this.repository,
    required this.saveSettingsUsecase,  // ← Nowa
  }) : super(VisualizationInitial());
  
  // Nowa metoda
  Future<void> saveSettings() async {
    final state = this.state;
    if (state is VisualizationLoaded) {
      try {
        final config = VisualizationConfig(
          heading: state.heading,
          showHull: state.showHull,
          showBowArrow: state.showBowArrow,
          vesselType: state.selectedVesselType,
        );
        await saveSettingsUsecase(config);
      } catch (e) {
        emit(VisualizationError('Failed to save settings: $e'));
      }
    }
  }
}
```

---

## EXAMPLE 4: Dependency Injection - Rejestracja nowej feature

```dart
// lib/core/di/service_locator.dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setupServiceLocator() async {
  // Existing registrations...
  
  // Nowe rejestracje dla Settings
  final prefs = await SharedPreferences.getInstance();
  
  getIt.registerSingleton<SharedPreferences>(prefs);
  
  getIt.registerSingleton<SettingsRepository>(
    SettingsRepositoryImpl(prefs: getIt<SharedPreferences>()),
  );
  
  getIt.registerSingleton<SaveSettingsUsecase>(
    SaveSettingsUsecase(repository: getIt<SettingsRepository>()),
  );
  
  // Zaktualizuj VisualizationCubit
  getIt.registerSingleton<VisualizationCubit>(
    VisualizationCubit(
      initializeUsecase: getIt<InitializeVisualizationUsecase>(),
      repository: getIt<VisualizationRepositoryImpl>(),
      saveSettingsUsecase: getIt<SaveSettingsUsecase>(),  // ← Dodaj
    ),
  );
}
```

---

## EXAMPLE 5: Używanie w UI

```dart
// lib/presentation/widgets/visualization_content.dart
class VisualizationContent extends StatelessWidget {
  final VisualizationLoaded state;
  
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VisualizationCubit>();
    
    return Column(
      children: [
        // ... existing widgets ...
        
        // Nowy przycisk do zapisania ustawień
        ElevatedButton(
          onPressed: () async {
            await cubit.saveSettings();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Settings saved!')),
            );
          },
          child: Text('Save Settings'),
        ),
      ],
    );
  }
}
```

---

## EXAMPLE 6: Testowanie nowej feature

```dart
// test/presentation/cubit/visualization_cubit_save_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSaveSettingsUsecase extends Mock implements SaveSettingsUsecase {}

void main() {
  group('VisualizationCubit - Save Settings', () {
    late VisualizationCubit cubit;
    late MockSaveSettingsUsecase mockSaveSettings;
    
    setUp(() {
      mockSaveSettings = MockSaveSettingsUsecase();
      
      cubit = VisualizationCubit(
        initializeUsecase: mockInitializeUsecase,
        repository: mockRepository,
        saveSettingsUsecase: mockSaveSettings,
      );
    });
    
    test('saveSettings calls usecase with current state', () async {
      // Arrange
      cubit.emit(VisualizationLoaded(
        availableVesselTypes: ['type1'],
        selectedVesselType: 'type1',
        heading: 180.0,
        showHull: true,
        showBowArrow: false,
      ));
      
      // Act
      await cubit.saveSettings();
      
      // Assert
      verify(mockSaveSettings(any)).called(1);
    });
  });
}
```

---

## EXAMPLE 7: Error Handling Pattern

```dart
// Proper error handling w Cubicie
Future<void> initialize() async {
  try {
    emit(VisualizationLoading());
    
    // Walidacja
    if (repository.getAvailableVesselTypes().isEmpty) {
      throw Exception('No vessel types available');
    }
    
    await initializeUsecase();
    
    final vesselTypes = repository.getAvailableVesselTypes();
    final defaultVessel = repository.getDefaultVesselType() ?? vesselTypes.first;
    
    emit(VisualizationLoaded(
      availableVesselTypes: vesselTypes,
      selectedVesselType: defaultVessel,
      heading: 90.0,
      showHull: true,
      showBowArrow: true,
    ));
  } on SocketException catch (e) {
    emit(VisualizationError('Network error: ${e.message}'));
  } on FormatException catch (e) {
    emit(VisualizationError('Data format error: ${e.message}'));
  } catch (e) {
    emit(VisualizationError('Unexpected error: $e'));
  }
}
```

---

## EXAMPLE 8: Advanced GetIt Usage

```dart
// Lazy singleton - created only when first accessed
getIt.registerLazySingleton<VisualizationCubit>(
  () => VisualizationCubit(
    initializeUsecase: getIt<InitializeVisualizationUsecase>(),
    repository: getIt<VisualizationRepositoryImpl>(),
  ),
);

// Factory - new instance each time
getIt.registerFactory<VisualizationPage>(
  () => VisualizationPage(),
);

// Conditional registration
if (kDebugMode) {
  getIt.registerSingleton<Logger>(DebugLogger());
} else {
  getIt.registerSingleton<Logger>(ProductionLogger());
}

// Reset service locator (useful in tests)
tearDown(() {
  getIt.reset();
});
```

---

## BEST PRACTICES CHECKLIST

### ✅ Architecture Best Practices:

**1. Domain Layer**
- ✅ Niezależna od frameworku
- ✅ Pure business logic
- ✅ Abstract repositories
- ✅ Usecases jako orchestrators

**2. Data Layer**
- ✅ Implementuje repositories
- ✅ Obsługuje API/Database/Cache
- ✅ Mapuje do Domain entities
- ✅ Error handling

**3. Presentation Layer**
- ✅ Cubits dla state management
- ✅ Pages dla routes
- ✅ Widgets dla UI components
- ✅ BlocBuilder/BlocListener dla reactions

**4. Dependency Injection**
- ✅ Wszystkie zależności w service_locator
- ✅ Singleton dla repositories/usecases
- ✅ Factory dla widgets
- ✅ Mockowanie w testach

**5. Code Quality**
- ✅ Type safety (full annotations)
- ✅ Error handling (try-catch)
- ✅ Documentation (doc comments)
- ✅ Testing (unit + widget tests)

### ❌ Anti-Patterns to Avoid:
- ❌ Nie mix business logic z UI
- ❌ Nie bezpośredni dostęp do API z widgetów
- ❌ Nie statyczne references bez GetIt
- ❌ Nie long methods (extract to smaller functions)
- ❌ Nie duplicate code (extract to utilities)

---

## 🎯 Pattern Selection Guide

| Potrzeba | Pattern | Użyj |
|----------|---------|------|
| Single instance | Singleton | `registerSingleton` |
| New instance each time | Factory | `registerFactory` |
| Created only when needed | Lazy Singleton | `registerLazySingleton` |
| Complex initialization | Builder | `registerSingleton(MyClass.build())` |
| Environment-specific | Conditional registration | `if (kDebugMode) {...}` |
| Async initialization | Async setup | `setupServiceLocator` as async |

