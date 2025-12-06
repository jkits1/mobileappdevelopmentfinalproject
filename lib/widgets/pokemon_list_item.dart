import 'package:flutter/material.dart';
import 'package:mobileappdevelopmentfinalproject/models/pokemon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonListItem extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonListItem({
    required this.pokemon,
    required this.onTap,
    super.key,
  });

  //just used to get an icon
  Future<String?> fetchIconUrl(int speciesId) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$speciesId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // The icon is usually in sprites.front_default
        return data['sprites']['front_default'] as String?;
      }
    } catch (e) {
      print('Error fetching icon: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FutureBuilder<String?>(
        future: fetchIconUrl(pokemon.pokemonId), // or speciesId if you store that
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return Image.network(
              snapshot.data!,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            );
          } else {
            // fallback icon
            return const Icon(Icons.catching_pokemon);
          }
        },
      ),
      title: Text(
        pokemon.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pokédex #${pokemon.pokemonId}"),
          Text("Types: ${pokemon.types.join(", ")}"),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}