import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PokemonCaptureInfo extends StatefulWidget {
  final int baseExperience;
  final DateTime captureDate;

  const PokemonCaptureInfo({
    super.key,
    required this.baseExperience,
    required this.captureDate,
  });

  @override
  State<PokemonCaptureInfo> createState() => _PokemonCaptureInfoState();
}

class _PokemonCaptureInfoState extends State<PokemonCaptureInfo> {
  bool _showExperience = false;

  void _toggleExperience() {
    setState(() {
      _showExperience = !_showExperience;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM d, yyyy').format(widget.captureDate);

    return GestureDetector(
      onTap: _toggleExperience,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Captured on $formattedDate',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            if (_showExperience) ...[
              const SizedBox(height: 4),
              Text(
                'Base XP: ${widget.baseExperience}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}