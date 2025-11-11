# ⚡ Quick Start Guide - LightVisu Architecture

## 30-Sekundowy Przegląd

**LightVisu** to Flutter app z **Clean Architecture** - idealna do nauki best practices.

```
Presentation (Pages, Cubits, Widgets)
         ↓
Domain (Entities, Repositories, Usecases)
         ↓
Data (Repository Implementations)
         ↓
External (JSON Assets, API, Cache)
```

---

## 🚀 Uruchomienie (5 minut)

```bash
# 1. Pobierz zależności
flutter pub get

# 2. Uruchom na Linux/Mac/Windows
flutter run -d linux

# 3. Interakcje
- Użyj slidera do zmiany kierunku statku
- Przełącz między zakładkami (Visualization / Quiz)
- Zmień typ statku z dropdown
```

---

## 📁 Gdzie Co Jest?

| Ścieżka | Co | Opis |
|--------|----|----- |
| `lib/domain/` | 💼 Business Logic | Niezależne od Flutter |
| `lib/data/` | 🗄️ Data Access | Dostęp do JSON assets |
| `lib/presentation/` | 🎨 UI Layer | Cubits, Pages, Widgets |
| `lib/core/` | ⚙️ Setup | DI, Config |
| `main.dart` | 🚀 Entry Point | Inicjalizacja |

---

## 🧠 Jak Dodać Nową Feature?

### Krok 1: Domain (Biznes)
```dart
// lib/domain/repositories/my_repository.dart
abstract class MyRepository {
  Future<void> doSomething();
}
```

### Krok 2: Data (Implementacja)
```dart
// lib/data/repositories/my_repository_impl.dart
class MyRepositoryImpl implements MyRepository {
  @override
  Future<void> doSomething() async { /* ... */ }
}
```

### Krok 3: Presentation (UI)
```dart
// lib/presentation/cubit/my_cubit.dart
class MyCubit extends Cubit<MyState> {
  Future<void> myMethod() async {
    emit(MyLoading());
    try {
      await repository.doSomething();
      emit(MyLoaded());
    } catch(e) {
      emit(MyError());
    }
  }
}
```

### Krok 4: DI (Rejestracja)
```dart
// lib/core/di/service_locator.dart
getIt.registerSingleton<MyRepository>(MyRepositoryImpl());
getIt.registerSingleton<MyCubit>(MyCubit(...));
```

---

## 💡 Kluczowe Pojęcia

### Cubit (State Management)
```dart
// Cubit emituje stany
emit(LoadingState());
emit(LoadedState(data));
emit(ErrorState(error));

// UI słucha stanów
BlocBuilder<MyCubit, MyState>(
  builder: (context, state) {
    if (state is LoadingState) return Loading();
    if (state is LoadedState) return Content();
    if (state is ErrorState) return Error();
  }
)
```

### Repository (Data Access)
```dart
// Abstrakcja - nie zależy od implementacji
abstract class MyRepository {
  Future<List<Item>> getItems();
}

// Implementacja
class MyRepositoryImpl implements MyRepository {
  @override
  Future<List<Item>> getItems() async {
    return await loadFromJSON();
  }
}
```

### GetIt (Dependency Injection)
```dart
// Rejestruj
getIt.registerSingleton<MyCubit>(MyCubit());

// Używaj
final cubit = getIt<MyCubit>();
```

---

## 🎯 Ćwiczenie: Dodaj Nową Funkcję

**Zadanie**: Dodaj feature do zapisania ostatniego kierunku

### Rozwiązanie:

**1. Domain** - Definiuj interfejs
```dart
abstract class PreferencesRepository {
  Future<void> saveHeading(double heading);
  Future<double> getLastHeading();
}
```

**2. Data** - Implementuj
```dart
class PreferencesRepositoryImpl implements PreferencesRepository {
  @override
  Future<void> saveHeading(double heading) async {
    // Zapisz do SharedPreferences
  }
}
```

**3. Cubit** - Dodaj metodę
```dart
Future<void> saveHeading(double heading) async {
  await preferencesRepository.saveHeading(heading);
}
```

**4. DI** - Zarejestruj
```dart
getIt.registerSingleton<PreferencesRepository>(
  PreferencesRepositoryImpl(),
);
```

✅ Done! Nowa feature gotowa.

---

## 📊 Architecture Pattern

```
┌─────────────────────┐
│   USER INTERACTION  │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  UI (BlocBuilder)   │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  Cubit Method       │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  Emit New State     │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│  BlocListener       │
│  (UI Updates)       │
└─────────────────────┘
```

---

## 🧪 Testowanie

```dart
// Mock repository
class MockMyRepository extends Mock implements MyRepository {}

// Test
test('Cubit emits loaded state', () {
  final mock = MockMyRepository();
  final cubit = MyCubit(repository: mock);
  
  cubit.load();
  
  expect(cubit.stream, emits(LoadedState()));
});
```

---

## 📚 Dokumentacja

- **ARCHITECTURE.md** - Szczegóły
- **DEVELOPMENT_GUIDE.md** - Wytyczne
- **ARCHITECTURE_EXAMPLES.md** - Przykłady

---

## ❓ FAQ

**Q: Dlaczego Domain Layer?**  
A: Aby business logic była niezależna od Fluttera - można reużyć w innym projekcie.

**Q: Dlaczego abstrakcyjne Repositories?**  
A: Aby łatwo mockować w testach i zamieniać implementacje.

**Q: Kiedy użyć GetIt?**  
A: Do wstrzyknięcia zależności - zamiast `new MyClass()` używamy `getIt<MyClass>()`.

**Q: Czy muszę mieć 4 warstwy?**  
A: Nie, ale to best practice dla dużych projektów. Mały projekt może mieć mniej.

---

## 🎓 Nauczanie się

1. **Przeczytaj**: ARCHITECTURE.md
2. **Eksploruj**: Kod w `lib/domain/`, `lib/data/`, `lib/presentation/`
3. **Ćwicz**: Dodaj własną feature
4. **Testuj**: Napraw warningi (`flutter analyze`)

---

## 🚀 Deployment

```bash
# Build for production
flutter build linux --release
flutter build apk --release
flutter build ios --release

# Run on device
flutter run -d android
flutter run -d ios
```

---

## 💬 Więcej Informacji?

- GitHub: [lightvisu](https://github.com/mecharolnik/lightvisu)
- Docs: Poczytaj *.md pliki w repo
- Questions: Otwórz Issue

---

**Happy Coding! 🎉**

*Ostatnia aktualizacja: 10 Listopada 2025*
