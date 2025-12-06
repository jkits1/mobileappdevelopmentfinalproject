import 'package:flutter/material.dart';

class PokemonStats extends StatelessWidget {
  final int id;
  final double height;
  final double weight;

  const PokemonStats({
    super.key,
    required this.id,
    required this.height,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '#$id',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Height: $height m',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 2),
        Text(
          'Weight: $weight kg',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
