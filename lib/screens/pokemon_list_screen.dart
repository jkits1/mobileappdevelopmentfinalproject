
import 'package:mobileappdevelopmentfinalproject/managers/preferences_manager.dart';
import 'package:mobileappdevelopmentfinalproject/routes.dart' as routes;
import 'package:mobileappdevelopmentfinalproject/models/pokemon.dart';
import 'package:flutter/material.dart';

class PokemonListScreen extends StatefulWidget {

  final bool darkMode;
  final Function(bool) onThemeChanged;

  const PokemonListScreen({
    required this.darkMode,
    required this.onThemeChanged,
    super.key,
  });

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> 
{
  final _prefsManager = PreferencesManager.instance;
  List<Pokemon> _pokemon = [];
  String _userName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userName = await _prefsManager.getUserName();

    setState(() {
      _userName = userName ?? 'User';
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_userName\'s Pokemon'),
        actions: [
          IconButton(
            icon: Icon(widget.darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              widget.onThemeChanged(!widget.darkMode);
            },
            tooltip:
                widget.darkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
          ),
        ],
      ),
    );
  }
}
