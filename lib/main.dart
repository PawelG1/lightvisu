import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deckmate/core/di/service_locator.dart';
import 'package:deckmate/presentation/cubit/quiz/quiz_cubit.dart';
import 'package:deckmate/presentation/cubit/visualization/visualization_cubit.dart';
import 'package:deckmate/presentation/pages/visualization_page.dart';
import 'package:deckmate/presentation/pages/quiz_page.dart';
import 'package:deckmate/presentation/screens/terms_and_conditions_screen.dart';
import 'package:deckmate/presentation/screens/settings_screen.dart';

void main() async {
  // IMPORTANT: Initialize WidgetsFlutterBinding BEFORE setupServiceLocator
  // Because rootBundle (Assets) requires initialized binding
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize service locator
  setupServiceLocator();
  
  // Initialize app data
  await getIt<VisualizationCubit>().initialize();
  await getIt<QuizCubit>().initialize();
  
  // Check if user has accepted terms and conditions
  final prefs = await SharedPreferences.getInstance();
  final termsAccepted = prefs.getBool('terms_accepted') ?? false;
  
  runApp(MainApp(termsAccepted: termsAccepted));
}

class MainApp extends StatefulWidget {
  final bool termsAccepted;

  const MainApp({
    required this.termsAccepted,
    super.key,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentPageIndex = 0;
  late bool _termsAccepted;

  @override
  void initState() {
    super.initState();
    _termsAccepted = widget.termsAccepted;
  }

  @override
  Widget build(BuildContext context) {
    // If terms not accepted, show Terms & Conditions screen
    if (!_termsAccepted) {
      return MaterialApp(
        title: 'DeckMate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: TermsAndConditionsScreen(
          onAccept: (accepted) async {
            if (accepted) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('terms_accepted', true);
              setState(() {
                _termsAccepted = true;
              });
            }
          },
        ),
      );
    }

    // Main app - show after terms accepted
    return MaterialApp(
      title: 'DeckMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _buildPage(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex,
          onTap: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.sailing),
              label: 'Visualization',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz),
              label: 'Quiz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    // Settings tab doesn't need BlocProvider
    if (_currentPageIndex == 2) {
      return const SettingsScreen();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<VisualizationCubit>.value(
          value: getIt<VisualizationCubit>(),
        ),
        BlocProvider<QuizCubit>.value(
          value: getIt<QuizCubit>(),
        ),
      ],
      child: _currentPageIndex == 0 ? VisualizationPage() : QuizPage(),
    );
  }
}
