import 'package:flutter/material.dart';
import 'package:mobileappdevelopmentfinalproject/models/pokemon.dart';

class PokemonListItem extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonListItem({
    required this.pokemon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
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