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
 Future<String?> fetchAnimatedIconUrl(int speciesId) async {
  final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$speciesId');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Try to get the animated front sprite
      final animated = data['sprites']?['other']?['showdown']?['front_default'];

      if (animated != null) {
      return animated as String;
      }

      // fallback to official artwork
      final official = data['sprites']?['other']?['official-artwork']?['front_default'];
      if (official != null) {
      return official as String;
      }
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
        future: fetchAnimatedIconUrl(pokemon.pokemonId),
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