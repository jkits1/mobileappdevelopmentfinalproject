import 'package:flutter/material.dart';
import 'package:mobileappdevelopmentfinalproject/screens/pokemon_add_screen.dart';
import 'dart:io';
import 'package:mobileappdevelopmentfinalproject/screens/pokemon_list_screen.dart';
import 'package:mobileappdevelopmentfinalproject/screens/welcome_screen.dart';
import 'package:mobileappdevelopmentfinalproject/routes.dart' as routes;
import 'package:mobileappdevelopmentfinalproject/managers/preferences_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferencesManager.instance;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PreferencesManager _prefsManager = PreferencesManager.instance;
  bool _isFirstRun = true;
  bool _darkMode = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final isFirstRun = await _prefsManager.isFirstRun();
    final storedDarkMode = await _prefsManager.getDarkMode();

    setState(() {
      _isFirstRun = isFirstRun;
      _darkMode = storedDarkMode;
      _isLoading = false;
    });
  }

  void _setDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
    _prefsManager.setDarkMode(value);
  }

  void _completeFirstRun() async {
    await _loadPreferences(); 
    setState(() {
      _isFirstRun = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Pokemon Manager',
      theme: _darkMode ? ThemeData.dark() : ThemeData.light(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case routes.welcome:
            return MaterialPageRoute(
              builder: (_) => WelcomeScreen(onComplete: _completeFirstRun),
            );
          case routes.pokemonListScreen:
            return MaterialPageRoute(builder: (_) => PokemonListScreen(
                    darkMode: _darkMode,
                    onThemeChanged: _setDarkMode,
                  ),
          );

          case routes.addPokemon:
            return MaterialPageRoute(builder: (_) => PokemonFormScreen( ),
          );

          default:
            return MaterialPageRoute(
              builder:
                  (_) => const Scaffold(
                    body: Center(child: Text('Route not found')),
                  ),
            );
        }
      },
      home:
          _isFirstRun
              ? WelcomeScreen(onComplete: _completeFirstRun)
              : PokemonListScreen(
                darkMode: _darkMode,
                onThemeChanged: _setDarkMode,
              ),
    );
  }
}

