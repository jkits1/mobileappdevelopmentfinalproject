import 'package:flutter/material.dart';
import 'package:mobileappdevelopmentfinalproject/models/pokemon.dart';
import 'package:mobileappdevelopmentfinalproject/managers/pokemon_manager.dart';

class PokemonFormScreen extends StatefulWidget {
  final Pokemon? pokemon;

  const PokemonFormScreen({this.pokemon, super.key});

  @override
  State<PokemonFormScreen> createState() => _PokemonFormScreenState();
}

class _PokemonFormScreenState extends State<PokemonFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _baseExpController = TextEditingController();

  List<String> _selectedTypes = [];
  DateTime _captureDate = DateTime.now();

  final _pokemonManager = PokemonManager.instance;

  @override
  void initState() {
    super.initState();

    if (widget.pokemon != null) {
      final p = widget.pokemon!;
      _nameController.text = p.name;
      _idController.text = p.pokemonId.toString();
      _heightController.text = p.height.toString();
      _weightController.text = p.weight.toString();
      _baseExpController.text = p.baseExperience.toString();
      _selectedTypes = List.from(p.types);
      _captureDate = p.captureDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _baseExpController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    return _formKey.currentState!.validate() && _selectedTypes.isNotEmpty;
  }

  Future<void> _savePokemon() async {
  if (!_validateForm()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fix errors in the form.")),
    );
    return;
  }

  try {
    final pokemon = Pokemon(
      id: widget.pokemon?.id, // keep existing DB ID
      pokemonId: int.parse(_idController.text.trim()), // Pokedex ID
      name: _nameController.text.trim(),
      height: double.parse(_heightController.text.trim()),
      weight: double.parse(_weightController.text.trim()),
      baseExperience: int.parse(_baseExpController.text.trim()),
      types: _selectedTypes,
      captureDate: _captureDate,
    );

    if (widget.pokemon == null) {
      await _pokemonManager.insertPokemon(pokemon);
    } else {
      await _pokemonManager.updatePokemon(pokemon);
    }

    if (mounted) Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving Pokémon: $e")),
    );
  }
}

  Future<void> _deletePokemon() async {
    if (widget.pokemon == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Pokémon'),
        content: const Text('Are you sure you want to delete this Pokémon?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      final dbId = widget.pokemon?.id;

      if (dbId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error: Pokémon has no database ID.")),
      );
      return;
      }

      await _pokemonManager.deletePokemon(dbId);

      if (mounted) {Navigator.pop(context, true);

      }

    }
}

  Future<void> _pickCaptureDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _captureDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (selected != null) {
      setState(() => _captureDate = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.pokemon != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Pokémon" : "Add Pokémon")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ---- Name ----
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? "Please enter a name"
                        : null,
              ),
              const SizedBox(height: 16),

              // ---- ID ----
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: "Pokédex ID",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final id = int.tryParse(value ?? "");
                  if (id == null || id <= 0) {
                    return "ID must be a positive number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---- Height ----
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: "Height (meters)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final h = double.tryParse(value ?? "");
                  if (h == null || h < 0.1 || h > 20.0) {
                    return "Height must be between 0.1 and 20.0";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---- Weight ----
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: "Weight (kg)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final w = double.tryParse(value ?? "");
                  if (w == null || w < 0.1 || w > 1000.0) {
                    return "Weight must be between 0.1 and 1000.0";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---- Base Experience ----
              TextFormField(
                controller: _baseExpController,
                decoration: const InputDecoration(
                  labelText: "Base Experience",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final exp = int.tryParse(value ?? "");
                  if (exp == null || exp < 1 || exp > 1000) {
                    return "Base Experience must be 1–1000";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ---- Types (multi-select) ----
              const Text("Types (1–2):"),
              Wrap(
                spacing: 8,
                children: Pokemon.validTypes.map((type) {
                  final isSelected = _selectedTypes.contains(type);

                  return FilterChip(
                    selected: isSelected,
                    label: Text(type),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          if (_selectedTypes.length < 2) {
                            _selectedTypes.add(type);
                          }
                        } else {
                          _selectedTypes.remove(type);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              if (_selectedTypes.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text("Select at least 1 type",
                      style: TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 16),

              // ---- Capture Date ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Captured: ${_captureDate.toLocal().toString().split(' ')[0]}",
                  ),
                  ElevatedButton(
                    onPressed: _pickCaptureDate,
                    child: const Text("Change Date"),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ---- Save ----
              ElevatedButton(
                onPressed: _savePokemon,
                child: Text(isEditing ? "Update" : "Add"),
              ),

              // ---- Delete (only when editing) ----
              if (isEditing) ...[
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _deletePokemon,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}