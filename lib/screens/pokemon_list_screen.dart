
import 'package:mobileappdevelopmentfinalproject/managers/preferences_manager.dart';
import 'package:mobileappdevelopmentfinalproject/managers/pokemon_manager.dart';
import 'package:mobileappdevelopmentfinalproject/routes.dart' as routes;
import 'package:mobileappdevelopmentfinalproject/models/pokemon.dart';
import 'package:mobileappdevelopmentfinalproject/widgets/pokemon_list_item.dart';
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

    final pokemonList = await PokemonManager.instance.getAllPokemon();

    setState(() {
      _userName = userName ?? 'User';
      _pokemon = pokemonList;
      _isLoading = false;
    });
  }

Future<void> _addPokemon() async {
  final result = await Navigator.pushNamed(context, routes.addPokemon);
  if (result == true) {
    await _loadData();
  }
}

Future<void> _editPokemon(Pokemon pokemon) async {
  final result = await Navigator.pushNamed(
    context,
    routes.editPokemon,
    arguments: pokemon,
  );
  if (result == true) {
    await _loadData();
  }
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
      body:_isLoading
        ? const Center(child: CircularProgressIndicator())
        : _pokemon.isEmpty
        ? const Center(
          child:Text('No Pokemon yet. Add your first Pokemon!')
        ) : ListView.separated(
            itemCount: _pokemon.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index)
            {
              final pokemonNew = _pokemon[index];
              return PokemonListItem(
              pokemon: pokemonNew,
              onTap: () => _editPokemon(pokemonNew)
            );
            },
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: _addPokemon,
        child: const Icon(Icons.add),
        ),
          
    );
  }
}
